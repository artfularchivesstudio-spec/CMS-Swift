//
//  KeychainManager.swift
//  CMS-Manager
//
//  🔑 The Keychain Manager - Guardian of Digital Secrets
//
//  "In the vault of silicon, where keys reside secure,
//   this keeper watches over tokens, holding secrets
//   dear and safe from prying eyes in the digital night."
//
//  - The Spellbinding Museum Director of Security
//

import Foundation

// MARK: - 🔑 Keychain Keys

/// 🗝️ The sacred keys that unlock our digital treasures
enum KeychainKey: String {
    case apiToken = "com.artfularchives.apiToken"
    case refreshToken = "com.artfularchives.refreshToken"
    case userId = "com.artfularchives.userId"
    case username = "com.artfularchives.username"
}

// MARK: - 🎭 Keychain Manager Actor

/// 🔐 Thread-safe keychain operations using Swift concurrency
actor KeychainManager: KeychainManagerProtocol {

    // MARK: - 🏺 Private Properties

    /// 🏰 The keychain service identifier
    private let service = "com.artfularchives.studio"

    /// 🧙‍♂️ The underlying KeychainAccess wrapper
    private let keychain: any KeychainWrapperProtocol

    // MARK: - 🎭 Initialization

    /// 🌟 Create a new keychain manager
    init(keychain: any KeychainWrapperProtocol = KeychainWrapper()) {
        self.keychain = keychain
    }

    // MARK: - 🔐 CRUD Operations

    /// 💾 Save a value to the keychain
    /// - Parameters:
    ///   - value: The string value to save
    ///   - key: The key to associate with the value
    func save(_ value: String, for key: KeychainKey) async throws {
        print("🔐 💾 Storing secret for key: \(key.rawValue)")

        do {
            try keychain.set(value, key: key.rawValue, service: service)
            print("🎉 ✨ Secret safely locked away!")
        } catch {
            print("💥 😭 KEYCHAIN STORAGE FAILED! \(error.localizedDescription)")
            throw KeychainError.storageFailed(key.rawValue, error)
        }
    }

    /// 🔍 Retrieve a value from the keychain
    /// - Parameter key: The key to look up
    /// - Returns: The stored value, or nil if not found
    func retrieve(for key: KeychainKey) async throws -> String? {
        print("🔍 🔓 Seeking secret for key: \(key.rawValue)")

        do {
            let value = try keychain.get(key.rawValue, service: service)
            if let value {
                print("🎉 ✨ Secret successfully retrieved!")
            } else {
                print("🌙 ⚠️ No secret found for this key")
            }
            return value
        } catch {
            print("💥 😭 KEYCHAIN RETRIEVAL FAILED! \(error.localizedDescription)")
            throw KeychainError.retrievalFailed(key.rawValue, error)
        }
    }

    /// 🗑️ Delete a value from the keychain
    /// - Parameter key: The key to delete
    func delete(for key: KeychainKey) async throws {
        print("🗑️ 💨 Purging secret for key: \(key.rawValue)")

        do {
            try keychain.remove(key.rawValue, service: service)
            print("🎉 ✨ Secret successfully vanquished!")
        } catch {
            print("💥 😭 KEYCHAIN DELETION FAILED! \(error.localizedDescription)")
            throw KeychainError.deletionFailed(key.rawValue, error)
        }
    }

    /// 🧹 Clear all stored secrets
    func clearAll() async throws {
        print("🧹 🌊 Purging ALL secrets from the vault!")

        for key in KeychainKey.allCases {
            try? await delete(for: key)
        }

        print("🎉 ✨ Vault is now pristine and empty!")
    }

    /// 🔎 Check if a key exists
    /// - Parameter key: The key to check
    /// - Returns: True if the key has a stored value
    func exists(_ key: KeychainKey) async -> Bool {
        do {
            return try await retrieve(for: key) != nil
        } catch {
            return false
        }
    }
}

// MARK: - 🔑 Keychain Error

/// 🌩️ The tragic tales of keychain failures
enum KeychainError: LocalizedError {
    case storageFailed(String, Error)
    case retrievalFailed(String, Error)
    case deletionFailed(String, Error)

    var errorDescription: String? {
        switch self {
        case .storageFailed(let key, let error):
            return "Failed to store '\(key)': \(error.localizedDescription)"
        case .retrievalFailed(let key, let error):
            return "Failed to retrieve '\(key)': \(error.localizedDescription)"
        case .deletionFailed(let key, let error):
            return "Failed to delete '\(key)': \(error.localizedDescription)"
        }
    }
}

// MARK: - 🎭 Keychain Manager Protocol

/// 🎭 Protocol for keychain operations - enables testing
protocol KeychainManagerProtocol {
    func save(_ value: String, for key: KeychainKey) async throws
    func retrieve(for key: KeychainKey) async throws -> String?
    func delete(for key: KeychainKey) async throws
    func clearAll() async throws
    func exists(_ key: KeychainKey) async -> Bool
}

// MARK: - 📦 Keychain Wrapper

/// 📦 A simple wrapper around KeychainAccess library
/// In production, replace with actual KeychainAccess or use Security framework
struct KeychainWrapper: KeychainWrapperProtocol {

    func set(_ value: String, key: String, service: String) throws {
        // Using Security framework directly
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
            kSecValueData as String: value.data(using: .utf8)!,
            kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlock
        ]

        // First, delete any existing value
        SecItemDelete(query as CFDictionary)

        // Add the new value
        let status = SecItemAdd(query as CFDictionary, nil)

        guard status == errSecSuccess else {
            throw NSError(
                domain: NSOSStatusErrorDomain,
                code: Int(status),
                userInfo: [NSLocalizedDescriptionKey: "Keychain add failed"]
            )
        }
    }

    func get(_ key: String, service: String) throws -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        guard status == errSecSuccess,
              let data = result as? Data,
              let value = String(data: data, encoding: .utf8) else {
            if status == errSecItemNotFound {
                return nil
            }
            throw NSError(
                domain: NSOSStatusErrorDomain,
                code: Int(status),
                userInfo: [NSLocalizedDescriptionKey: "Keychain lookup failed"]
            )
        }

        return value
    }

    func remove(_ key: String, service: String) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key
        ]

        let status = SecItemDelete(query as CFDictionary)

        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw NSError(
                domain: NSOSStatusErrorDomain,
                code: Int(status),
                userInfo: [NSLocalizedDescriptionKey: "Keychain delete failed"]
            )
        }
    }
}

// MARK: - 🎭 Keychain Wrapper Protocol

/// 🎭 Protocol for keychain wrapper
protocol KeychainWrapperProtocol {
    func set(_ value: String, key: String, service: String) throws
    func get(_ key: String, service: String) throws -> String?
    func remove(_ key: String, service: String) throws
}

// MARK: - 🗝️ Keychain Key Extensions

extension KeychainKey: CaseIterable {
    static var allCases: [KeychainKey] {
        [.apiToken, .refreshToken, .userId, .username]
    }
}
