```bash
powershell -ExecutionPolicy Bypass -Command "Invoke-Expression $(Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/username/repository/main/script.ps1' -UseBasicParsing).Content"
```
