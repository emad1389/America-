# PasarGuard Node – Railway

این ریپو یک PasarGuard Node آماده برای Railway است.

## راه‌اندازی

1. ریپو را به عنوان یک Service در همان Railway Project و Environment پنل Deploy کنید.
2. اسم Service می‌تواند **هر چیزی** باشد؛ نیازی نیست `pasarguard-node` باشد.
3. در Variables فقط این موارد را تنظیم کنید:

```
SERVICE_PORT=62050
NODE_HOST=0.0.0.0
API_KEY=<یک UUID اختصاصی برای همین Node>
```

4. در Settings → Networking، برای همین Service یک TCP Proxy روی target port `62050` بسازید.
5. **Start Command را تغییر ندهید** و `sleep infinity` نگذارید. Docker image خودش Node را با `./main` اجرا می‌کند.
6. Volume برای `/app/certs` لازم نیست؛ گواهی داخل image ساخته می‌شود.
7. برای دریافت گواهی:

```bash
cat /app/certs/ssl_cert.pem
```

کل خروجی را در فیلد **Server CA / Certificate** پنل قرار دهید.

## اتصال پنل به Node داخلی Railway

اگر پنل و Node در همان Railway Project و Environment هستند، Address را با نام واقعی Service بنویسید:

```
<service-name>.railway.internal
```

مثلاً اگر Service را `iran-node` نام‌گذاری کرده‌اید:

```
iran-node.railway.internal
```

اگر نام واقعی Service در Railway برابر `america` باشد، آدرس داخلی آن:

```
america.railway.internal
```

این آدرس ثابت و عمومی نیست؛ باید دقیقاً با نام Service در Railway مطابقت داشته باشد و پنل و Node هم در یک Project و Environment باشند.

Port:

```
62050
```

API Key: همان مقدار `API_KEY` در Node.

گواهی این image شامل wildcard زیر است و به نام Service خاصی وابسته نیست:

```
*.railway.internal
```

بنابراین تغییر نام Service به `pasarguard-node` اجباری نیست.

## اتصال از طریق TCP Proxy

اگر به‌جای شبکه داخلی Railway از TCP Proxy استفاده می‌کنید، Address و Port را از Railway بگیرید و همان Certificate را در پنل قرار دهید. در این حالت باید مقدار `NODE_DOMAIN` هنگام build با hostname مربوط به TCP Proxy هماهنگ باشد.

## نکته مهم

`API_KEY` را برای هر Node جداگانه و به صورت UUID تصادفی بسازید. مقدار API Key نمونه این README را مستقیماً برای سرویس واقعی استفاده نکنید.
