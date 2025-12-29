/**
 * 🎭 The XCTestCase Snapshot Extensions - Enhanced Testing Powers
 *
 * "Behold! We bestow upon XCTestCase the mystical ability to capture snapshots
 * across multiple devices, color schemes, and orientations with a single spell.
 * What once required verbose repetition now flows like poetry."
 *
 * - The Spellbinding Museum Director of Test Extensions
 */

import XCTest
import SwiftUI
import SnapshotTesting
@testable import CMS_Manager

// MARK: - 🔧 Snapshot Directory Configuration

/// 📁 Find the source directory for snapshot storage (avoids sandbox issues)
private func findSnapshotDirectory(for file: StaticString) -> String? {
    // 🎯 First, try environment variable (for CI/CD and custom configs)
    if let envPath = ProcessInfo.processInfo.environment["SNAPSHOT_ARTIFACTS"] {
        print("📸 Using SNAPSHOT_ARTIFACTS path: \(envPath)")
        return envPath
    }

    // 🔍 Second, use the test file's directory
    // The file parameter gives us the actual source file path
    let filePath = "\(file)"
    let fileURL = URL(fileURLWithPath: filePath)
    let testDirectory = fileURL.deletingLastPathComponent().path
    let snapshotsPath = (testDirectory as NSString).appendingPathComponent("__Snapshots__")

    if FileManager.default.fileExists(atPath: testDirectory) {
        print("📸 Using test file directory: \(snapshotsPath)")
        return testDirectory
    }

    print("⚠️ Could not find source directory, using default")
    return nil
}

// MARK: - 🌟 Multi-Device Snapshot Assertions

extension XCTestCase {

    /**
     * 📸 Assert Snapshots Across All Devices - The Grand Ensemble
     *
     * Captures snapshots for every device in our test matrix.
     * One call to rule them all! 💍
     *
     * - Parameters:
     *   - view: The SwiftUI view to snapshot
     *   - devices: Array of devices to test (defaults to iPhone essentials)
     *   - colorScheme: Light or dark mode (defaults to light)
     *   - record: Whether to record new snapshots (defaults to false)
     *   - file: The file where the test is called (auto-filled)
     *   - testName: The name of the test (auto-filled)
     *   - line: The line number (auto-filled)
     */
    func assertAllDevices<V: View>(
        matching view: V,
        devices: [DeviceConfiguration] = DeviceConfiguration.iPhoneEssentials,
        colorScheme: ColorScheme = .light,
        record: Bool = false,
        file: StaticString = #file,
        testName: String = #function,
        line: UInt = #line
    ) {
        // 🎪 Iterate through each device in our ensemble
        for device in devices {
            let wrappedView = SnapshotViewWrapper.wrap(
                view,
                colorScheme: colorScheme,
                size: device.size
            )

            let snapshotName = SnapshotNaming.generateName(
                for: testName,
                device: device,
                colorScheme: colorScheme
            )

            // 📸 Capture the magical moment!
            // Note: Snapshot directory determined by SnapshotTesting library based on file path
            // For local testing, configure SNAPSHOT_ARTIFACTS env var in scheme
            assertSnapshot(
                of: wrappedView,
                as: .image(
                    layout: .fixed(width: device.size.width, height: device.size.height),
                    traits: UITraitCollection(userInterfaceStyle: colorScheme == .dark ? .dark : .light)
                ),
                named: snapshotName,
                record: record,
                file: file,
                testName: testName,
                line: line
            )
        }
    }

    /**
     * 🌈 Assert Snapshots in Both Color Schemes - The Duality
     *
     * Tests a view in both light and dark mode.
     * Because great UI works in all lighting conditions! ☀️🌙
     *
     * - Parameters:
     *   - view: The SwiftUI view to snapshot
     *   - devices: Array of devices to test (defaults to iPhone 13 Pro only)
     *   - record: Whether to record new snapshots
     *   - file: The file where the test is called
     *   - testName: The name of the test
     *   - line: The line number
     */
    func assertBothColorSchemes<V: View>(
        matching view: V,
        devices: [DeviceConfiguration] = [.iPhone13Pro],
        record: Bool = false,
        file: StaticString = #file,
        testName: String = #function,
        line: UInt = #line
    ) {
        // ☀️ Light mode magic
        assertAllDevices(
            matching: view,
            devices: devices,
            colorScheme: .light,
            record: record,
            file: file,
            testName: testName,
            line: line
        )

        // 🌙 Dark mode enchantment
        assertAllDevices(
            matching: view,
            devices: devices,
            colorScheme: .dark,
            record: record,
            file: file,
            testName: testName,
            line: line
        )
    }

    /**
     * 🎨 Assert Single Device Snapshot - The Solo Performance
     *
     * When you just need to test on one specific device.
     * Sometimes simplicity is the ultimate sophistication! 🎭
     *
     * - Parameters:
     *   - view: The SwiftUI view to snapshot
     *   - device: The device configuration to test
     *   - colorScheme: Light or dark mode
     *   - strategy: The snapshot comparison strategy
     *   - record: Whether to record new snapshots
     *   - file: The file where the test is called
     *   - testName: The name of the test
     *   - line: The line number
     */
    func assertDevice<V: View>(
        matching view: V,
        device: DeviceConfiguration = .iPhone13Pro,
        colorScheme: ColorScheme = .light,
        strategy: SnapshotStrategy = .exact,
        record: Bool = false,
        file: StaticString = #file,
        testName: String = #function,
        line: UInt = #line
    ) {
        let wrappedView = SnapshotViewWrapper.wrap(
            view,
            colorScheme: colorScheme,
            size: device.size
        )

        let snapshotName = SnapshotNaming.generateName(
            for: testName,
            device: device,
            colorScheme: colorScheme
        )

        // 📸 The solo snapshot!
        assertSnapshot(
            of: wrappedView,
            as: .image(
                layout: .fixed(width: device.size.width, height: device.size.height),
                traits: UITraitCollection(userInterfaceStyle: colorScheme == .dark ? .dark : .light)
            ),
            named: snapshotName,
            record: record,
            file: file,
            testName: testName,
            line: line
        )
    }

    /**
     * 🎪 Assert Dark Mode Only - The Night Shift
     *
     * Convenience method for testing dark mode exclusively.
     * For those views that shine in the darkness! 🌙✨
     *
     * - Parameters:
     *   - view: The SwiftUI view to snapshot
     *   - devices: Array of devices to test
     *   - record: Whether to record new snapshots
     *   - file: The file where the test is called
     *   - testName: The name of the test
     *   - line: The line number
     */
    func assertDarkMode<V: View>(
        matching view: V,
        devices: [DeviceConfiguration] = DeviceConfiguration.iPhoneEssentials,
        record: Bool = false,
        file: StaticString = #file,
        testName: String = #function,
        line: UInt = #line
    ) {
        assertAllDevices(
            matching: view,
            devices: devices,
            colorScheme: .dark,
            record: record,
            file: file,
            testName: testName,
            line: line
        )
    }

    /**
     * 📱 Assert iPad Snapshots - The Spacious Edition
     *
     * Test specifically on iPad devices.
     * Because tablet UI deserves love too! 💕
     *
     * - Parameters:
     *   - view: The SwiftUI view to snapshot
     *   - colorScheme: Light or dark mode
     *   - record: Whether to record new snapshots
     *   - file: The file where the test is called
     *   - testName: The name of the test
     *   - line: The line number
     */
    func assertIPads<V: View>(
        matching view: V,
        colorScheme: ColorScheme = .light,
        record: Bool = false,
        file: StaticString = #file,
        testName: String = #function,
        line: UInt = #line
    ) {
        assertAllDevices(
            matching: view,
            devices: DeviceConfiguration.iPads,
            colorScheme: colorScheme,
            record: record,
            file: file,
            testName: testName,
            line: line
        )
    }
}

// MARK: - 🎭 Snapshot Recording Mode Control

extension XCTestCase {

    /**
     * 📸 Recording Mode Flag - The Director's Cut Switch
     *
     * Set this to true when you need to record new snapshots.
     * Remember to set it back to false before committing! 🎬
     */
    var isRecordingSnapshots: Bool {
        // 🔮 You can override this per test class or read from environment
        ProcessInfo.processInfo.environment["SNAPSHOT_RECORDING"] == "true"
    }

    /**
     * 🎨 Snapshot Directory - Where the Magic Lives
     *
     * Returns the directory where snapshots are stored for this test case.
     */
    var snapshotDirectory: String {
        let className = String(describing: type(of: self))
        return "__Snapshots__/\(className)"
    }
}

// MARK: - 🌟 Custom Snapshot Strategies

extension XCTestCase {

    /**
     * ⚡ Fast Snapshot Testing - Speed Over Precision
     *
     * Use this for rapid iteration during development.
     * Perfect for that TDD flow! 🏃‍♂️💨
     */
    func assertFastSnapshot<V: View>(
        matching view: V,
        device: DeviceConfiguration = .iPhone13Pro,
        file: StaticString = #file,
        testName: String = #function,
        line: UInt = #line
    ) {
        assertDevice(
            matching: view,
            device: device,
            strategy: .fast,
            file: file,
            testName: testName,
            line: line
        )
    }

    /**
     * 🌊 Relaxed Snapshot Testing - Flexibility Wins
     *
     * When minor pixel differences are acceptable.
     * Great for views with system-rendered text! 📝
     */
    func assertRelaxedSnapshot<V: View>(
        matching view: V,
        device: DeviceConfiguration = .iPhone13Pro,
        file: StaticString = #file,
        testName: String = #function,
        line: UInt = #line
    ) {
        assertDevice(
            matching: view,
            device: device,
            strategy: .relaxed,
            file: file,
            testName: testName,
            line: line
        )
    }
}
