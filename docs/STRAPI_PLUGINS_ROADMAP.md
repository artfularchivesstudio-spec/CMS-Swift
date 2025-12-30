# 🔌 Strapi Plugins Enhancement Roadmap

> **Created:** December 30, 2024
> **Status:** Planning
> **Priority:** Pick up later

---

## 📋 Current Setup (Strapi v5)

Already using/built-in:
- ✅ **i18n (Internationalization)** - English, Spanish, Hindi locales
- ✅ **Draft & Publish** - Built into v5
- ✅ **Content History** - Built into v5
- ✅ **Custom Lifecycle Hooks** - One Brain sync to Supabase

---

## 🎯 High Priority Plugins

### 1. Cloudinary Upload Provider
**Why:** Move media (images + audio) to CDN for faster global delivery

```bash
npm install @strapi/provider-upload-cloudinary
```

**Benefits:**
- Automatic image optimization (WebP, responsive sizes)
- Audio file CDN delivery
- Reduced VPS storage usage
- Faster load times for iOS app

**Config:** `./config/plugins.js`
```javascript
module.exports = {
  upload: {
    config: {
      provider: 'cloudinary',
      providerOptions: {
        cloud_name: process.env.CLOUDINARY_NAME,
        api_key: process.env.CLOUDINARY_KEY,
        api_secret: process.env.CLOUDINARY_SECRET,
      },
    },
  },
};
```

**Docs:** https://market.strapi.io/providers/@strapi-provider-upload-cloudinary

---

### 2. Localazy Plugin (AI Translation)
**Why:** Bulk translate stories from English → Spanish/Hindi automatically

```bash
npm install @localazy/strapi-plugin@latest
npx @localazy/strapi-plugin
```

**Benefits:**
- AI-powered translation
- Continuous localization
- Bulk pre-translate all stories
- Human translator integration option

**Docs:** https://strapi.io/marketplace/plugins/@localazy-strapi-plugin

---

### 3. SEO Plugin
**Why:** Optimize story content for search engines (if publishing to web)

```bash
npm install @strapi/plugin-seo
```

**Benefits:**
- Meta title/description fields
- SERP preview (Google results preview)
- Social share previews (Facebook, Twitter)
- SEO analysis with suggestions

**Docs:** https://strapi.io/blog/strapi-seo-plugins

---

### 4. Sitemap Plugin (Strapi v5)
**Why:** Auto-generate XML sitemap for search engine indexing

```bash
npm install strapi-5-sitemap-plugin
```

**Benefits:**
- Dynamic sitemap generation
- Cron-based regeneration
- Sitemap indexes for large sites
- Exclude specific URLs

**Docs:** https://market.strapi.io/plugins/strapi-5-sitemap-plugin

---

## 🌟 Nice to Have Plugins

### 5. Scheduler Plugin
**Why:** Auto-publish/unpublish stories at specific times

**Use Case:**
- Schedule story releases
- Unpublish seasonal content automatically
- Content calendar workflow

---

### 6. Comments Plugin
**Why:** Add user comments to stories (if needed)

**Use Case:**
- Moderation system in admin panel
- Approve/reject comments
- Community engagement

---

### 7. Sentry Plugin
**Why:** Error monitoring for production

```bash
npm install @strapi/plugin-sentry
```

**Benefits:**
- Real-time error logs
- Stack traces
- Performance metrics
- Release tracking

---

### 8. Import/Export Plugin
**Why:** Bulk content backup and migration

**Use Case:**
- Backup all stories
- Migrate between environments
- Bulk content operations

---

## 🤖 Built-in Strapi v5 AI Feature

**AI-Powered Internationalization** (no plugin needed!)

**Enable:**
> Settings > Global Settings > Internationalization > AI Translations = Enabled

**What it does:**
- Automatically translates content when default locale is updated
- All locales translated within seconds
- Great for Spanish/Hindi translations

---

## 📱 Translation UI Enhancement (iOS App)

**Current State:** Stories list shows all locales separately

**Proposed Enhancement:**
1. API filters by `locale=en` (show only English in list)
2. Story detail shows "Translations Available" section
3. Filter chip to toggle translation visibility

**Implementation Options:**

**Option A: API-side filtering**
```
GET /api/v1/stories?locale=en
```
Returns only English stories, with `translations_available: ["es", "hi"]`

**Option B: Group by document_id**
```json
{
  "document_id": "abc123",
  "main": { /* English story */ },
  "translations": [
    { "locale": "es", "title": "Título en español" },
    { "locale": "hi", "title": "हिंदी शीर्षक" }
  ]
}
```

---

## 🗓️ Implementation Priority

| Phase | Plugin/Feature | Effort | Impact |
|-------|---------------|--------|--------|
| 1 | AI Translations (built-in) | Low | High |
| 2 | Translation UI (iOS) | Medium | High |
| 3 | Cloudinary | Medium | High |
| 4 | Localazy | Low | Medium |
| 5 | SEO + Sitemap | Low | Medium |
| 6 | Scheduler | Low | Low |

---

## 📚 Resources

- [Strapi Marketplace](https://market.strapi.io/)
- [Strapi v5 Documentation](https://docs.strapi.io/)
- [Strapi i18n Guide](https://strapi.io/blog/strapi-5-i18n-complete-guide)
- [Cloudinary + Strapi](https://strapi.io/integrations/cloudinary-1)

---

*Pick this up when ready to enhance the CMS!* ✨
