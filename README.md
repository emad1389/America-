# PasarGuard Node – Multi-Instance Railway

این ریپو برای اجرای چند **PasarGuard Node** مستقل روی Railway آماده شده است.

## نکته مهم

محدودیت تعداد Node از طرف `API_KEY` در خود Node وجود ندارد؛ هر سرویس Railway یک Node مستقل است و می‌تواند API Key جداگانه، TCP Proxy جداگانه و تنظیمات خودش را داشته باشد.

بنابراین می‌توانی از همین ریپو چند Service بسازی؛ مثلاً:

- Node-IR
- Node-US
- Node-DE

هر Service یک instance جدا از Node خواهد بود.

## راه‌اندازی هر Service

### 1. ساخت Service

در Railway:

**+ New → GitHub Repo → `emad1389/America-`**

Branch را روی:

```
multi-node-railway
```

بگذار.

برای هر Node یک Service جدا بساز.

### 2. متغیرهای هر Service

در **Variables** حداقل این دو مقدار را قرار بده:

```
API_KEY=یک UUID متفاوت برای این Node
NODE_DOMAIN=hostname مربوط به TCP Proxy همین Service
```

مثال:

Service اول:

```
API_KEY=11111111-1111-4111-8111-111111111111
NODE_DOMAIN=hostname-node-1
```

Service دوم:

```
API_KEY=22222222-2222-4222-8222-222222222222
NODE_DOMAIN=hostname-node-2
```

**نکته:** مقدار `NODE_DOMAIN` باید دقیقاً hostnameای باشد که Railway برای TCP Proxy همان Service می‌دهد، بدون پورت.

Railway متغیرهای Service را در زمان Build هم در اختیار Dockerfile قرار می‌دهد، به شرطی که در Dockerfile با `ARG` تعریف شده باشند. این Dockerfile همین کار را انجام می‌دهد.

### 3. TCP Proxy

برای هر Service:

**Settings → Networking → TCP Proxy**

Target Port:

```
62050
```

Railway برای هر Service یک TCP Proxy جدا می‌دهد.

### 4. Deploy

بعد از Deploy، هر Service یک Node مستقل خواهد بود.

برای گرفتن CA همان Service:

```
cat /app/certs/ssl_cert.pem
```

کل خروجی را کپی کن.

### 5. افزودن به PasarGuard

در پنل PasarGuard برای هر Node:

- **Address:** hostname همان TCP Proxy
- **Port:** پورت TCP Proxy همان Service
- **API Key:** همان `API_KEY` همان Service
- **Server CA:** گواهی همان Service

هر Node باید CA و API Key خودش را داشته باشد.

## نتیجه

مثلاً می‌توانی داشته باشی:

```
PasarGuard Panel
├── Node 1 → Railway Service 1 → Location 1
├── Node 2 → Railway Service 2 → Location 2
└── Node 3 → Railway Service 3 → Location 3
```

این تغییر فقط محدودیت و تنظیمات لازم برای اجرای چند instance را در ریپوی Railway برطرف می‌کند و کد اصلی PasarGuard Node را مستقیم fork یا تغییر نمی‌دهد.

## منبع

Node اصلی از:

https://github.com/PasarGuard/node

ساخته می‌شود.
