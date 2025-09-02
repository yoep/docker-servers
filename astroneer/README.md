# Astroneer Dedicated Server

Once the initial process has runned, and crashed, edit the following files.

Add the following config to `config/Engine.ini`

_config/Engine.ini_
```ini
[URL]
Port=8777

[SystemSettings]
net.AllowEncryption=False
```

Configure the following values within `config/AstroServerSettings.ini`:

_config/AstroServerSettings.ini_
```ini
PublicIP=X.X.X.X
ServerName=Lorem
```