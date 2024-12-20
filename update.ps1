# 开启调试
# Set-PSDebug -Trace 1

# 删除已有的文件
Remove-Item -Path .\bucket  -Recurse -Force
Remove-Item -Path .\scripts -Recurse -Force

# 将克隆的最新的文件拷贝到待处理的文件夹
New-Item -ItemType "directory" -Path ".\bucket"
New-Item -ItemType "directory" -Path ".\scripts"

# Scoop 官方的十个库
Copy-Item -Path ".\Main\bucket\*"               -Destination ".\bucket"  -Recurse -Force
Copy-Item -Path ".\Main\scripts\*"              -Destination ".\scripts" -Recurse -Force
Copy-Item -Path ".\Extras\bucket\*"             -Destination ".\bucket"  -Recurse -Force
Copy-Item -Path ".\Extras\scripts\*"            -Destination ".\scripts" -Recurse -Force
Copy-Item -Path ".\Versions\bucket\*"           -Destination ".\bucket"  -Recurse -Force
Copy-Item -Path ".\Versions\scripts\*"          -Destination ".\scripts" -Recurse -Force
Copy-Item -Path ".\Nonportable\bucket\*"        -Destination ".\bucket"  -Recurse -Force
Copy-Item -Path ".\Nonportable\scripts\*"       -Destination ".\scripts" -Recurse -Force
Copy-Item -Path ".\Java\bucket\*"               -Destination ".\bucket"  -Recurse -Force
Copy-Item -Path ".\PHP\bucket\*"                -Destination ".\bucket"  -Recurse -Force
Copy-Item -Path ".\scoop-nirsoft\bucket\*"      -Destination ".\bucket"  -Recurse -Force
Copy-Item -Path ".\scoop-nerd-fonts\bucket\*"   -Destination ".\bucket"  -Recurse -Force
Copy-Item -Path ".\scoop-games\bucket\*"        -Destination ".\bucket"  -Recurse -Force
Copy-Item -Path ".\scoop-games\scripts\*"       -Destination ".\scripts" -Recurse -Force
Copy-Item -Path ".\scoop-sysinternals\bucket\*" -Destination ".\bucket"  -Recurse -Force

# 复制完后，删掉克隆的文件夹
Remove-Item -Path .\Main               -Recurse -Force
Remove-Item -Path .\Extras             -Recurse -Force
Remove-Item -Path .\Versions           -Recurse -Force
Remove-Item -Path .\Nonportable        -Recurse -Force
Remove-Item -Path .\Java               -Recurse -Force
Remove-Item -Path .\PHP                -Recurse -Force
Remove-Item -Path .\scoop-nirsoft      -Recurse -Force
Remove-Item -Path .\scoop-nerd-fonts   -Recurse -Force
Remove-Item -Path .\scoop-games        -Recurse -Force
Remove-Item -Path .\scoop-sysinternals -Recurse -Force

Get-ChildItem -Recurse -Path .\bucket | ForEach-Object -Process {
    Write-Host $_.FullName 
    Measure-Command {
        $content = Get-Content $_.FullName

        # GitHub Releases
        $content = $content -replace '(github\.com/.+/releases/.*download)', 'mirror.ghproxy.com/https://$1' 

        # GitHub Archive
        $content = $content -replace '(github\.com/.+/archive/)', 'mirror.ghproxy.com/https://$1' 

        # GitHub Raw
        $content = $content -replace '(raw\.githubusercontent\.com)', 'mirror.ghproxy.com/https://$1' 
        $content = $content -replace '(github\.com/.+/raw/)', 'mirror.ghproxy.com/https://$1'          

        # SourceForge
        # Use jaist
        # $content = $content -replace '(//downloads\.sourceforge\.net/project/.+)(\")', '$1?use_mirror=jaist$2' 
        # $content = $content -replace '(#/.+)(\?use_mirror=jaist)', '$2$1' 
        # $content = $content -replace '(//sourceforge\.net/projects/.+/files/.+)(\")', '$1/download?use_mirror=jaist$2' 
        # $content = $content -replace '(#/.+)(/download\?use_mirror=jaist)', '$2$1' 
        # Or use zenlayer

        # KDE Apps
        $content = $content -replace 'download\.kde\.org', 'mirrors.ustc.edu.cn/kde' 

        # 7-Zip
        $content = $content -replace 'www\.7-zip\.org/a', 'mirror.nju.edu.cn/7-zip' 

        # LaTeX, MiKTeX
        $content = $content -replace '(miktex\.org/download/ctan)|(mirrors.+/CTAN)', 'mirrors.aliyun.com/CTAN' 

        # Node
        $content = $content -replace 'nodejs\.org/dist', 'npmmirror.com/mirrors/node' 
        # Or
        # $content = $content -replace 'nodejs\.org/dist', 'mirrors.aliyun.com/nodejs-release' 

        # Python
        $content = $content -replace 'www\.python\.org/ftp/python', 'npmmirror.com/mirrors/python' 

        # Go
        $content = $content -replace 'dl\.google\.com/go', 'mirrors.aliyun.com/golang' 

        # VLC
        $content = $content -replace 'download\.videolan\.org/pub', 'mirrors.aliyun.com/videolan' 

        # Inkscape
        $content = $content -replace 'media\.inkscape\.org/dl/resources/file', 'mirrors.nju.edu.cn/inkscape' 

        # DBeaver
        $content = $content -replace 'dbeaver\.io/files', 'mirror.ghproxy.com/https://github.com/dbeaver/dbeaver/releases/download' 
        # Or
        # $content = $content -replace 'dbeaver\.io/files', 'mirrors.nju.edu.cn/github-release/dbeaver/dbeaver' 

        # OBS Studio
        $content = $content -replace 'cdn-fastly\.obsproject\.com/downloads/OBS-Studio-(.+)-Windows\.zip', 'mirror.ghproxy.com/https://github.com/obsproject/obs-studio/releases/download/$1/OBS-Studio-$1-Windows.zip' 
        # Or
        # $content = $content -replace 'cdn-fastly\.obsproject\.com/downloads/OBS-Studio-(.+)-Windows\.zip', 'mirrors.nju.edu.cn/github-release/obsproject/obs-studio/OBS%20Studio%20$1/OBS-Studio-$1-Windows.zip' 
        # $content = $content -replace 'cdn-fastly\.obsproject\.com/downloads/OBS-Studio-(.+)-Windows\.zip', 'mirrors.tuna.tsinghua.edu.cn/github-release/obsproject/obs-studio/OBS%20Studio%20$1/OBS-Studio-$1-Windows.zip' 

        # OBS Studio 2.7
        $content = $content -replace 'cdn-fastly\.obsproject\.com/downloads/OBS-Studio-(.+)-Full', 'mirror.ghproxy.com/https://github.com/obsproject/obs-studio/releases/download/$1/OBS-Studio-$1-Full' 

        # GIMP
        $content = $content -replace 'download\.gimp\.org/mirror/pub', 'mirrors.aliyun.com/gimp' 

        # Blender
        $content = $content -replace 'download\.blender\.org', 'mirrors.aliyun.com/blender' 

        # VirtualBox
        $content = $content -replace 'download\.virtualbox\.org/virtualbox', 'mirrors.nju.edu.cn/virtualbox' 

        # Wireshark
        # $content = $content -replace 'www\.wireshark\.org/download', 'mirrors.nju.edu.cn/wireshark' 

        # Lunacy
        $content = $content -replace 'lun-eu\.icons8\.com/s/', 'lcdn.icons8.com/' 

        # Strawberry
        $content = $content -replace 'files\.jkvinge\.net/packages/strawberry/StrawberrySetup-(.+)-mingw-x', 'mirror.ghproxy.com/https://github.com/strawberrymusicplayer/strawberry/releases/download/$1/StrawberrySetup-$1-mingw-x' 

        # SumatraPDF
        # $content = $content -replace 'files\.sumatrapdfreader\.org/file/kjk-files/software/sumatrapdf/rel', 'www.sumatrapdfreader.org/dl/rel' 

        # Vim
        $content = $content -replace 'ftp\.nluug\.nl/pub/vim/pc', 'mirrors.ustc.edu.cn/vim/pc' 

        # Cygwin
        $content = $content -replace '//.*/cygwin/', '//mirrors.aliyun.com/cygwin/' 

        # Tor Browser, Tor
        # Or
        # https://tor.ybti.net/dist/
        # https://mirror.freedif.org/TorProject/dist
        # https://mirror.oldsql.cc/tor/dist/
        # https://tor.zilog.es/dist/
        # https://torproject.ph3x.at/dist/
        # https://www.eprci.com/tor/dist/
        # https://tor.calyxinstitute.org/dist/
        # https://torproject.mirror.metalgamer.eu/dist/
        # https://cyberside.net.ee/sibul/dist/
        $content = $content -replace 'archive\.torproject\.org/tor-package-archive', 'tor.calyxinstitute.org/dist/' 

        # FastCopy
        $content = $content -replace 'fastcopy\.jp/archive', 'mirror.ghproxy.com/https://raw.githubusercontent.com/FastCopyLab/FastCopyDist2/main' 

        # Kodi
        $content = $content -replace 'mirrors\.kodi\.tv', 'mirrors.tuna.tsinghua.edu.cn/kodi' 

        # Typora
        $content = $content -replace 'download\.typora\.io', 'download2.typoraio.cn' 

        # Scripts
        $content = $content -replace '(bucketsdir\\\\).+(\\\\scripts)', '$1scoop-cn$2' 

        # 将 suggest 路径改为 scoop-cn
        $content = $content -creplace '\"main/|\"extras/|\"versions/|\"nirsoft/|\"sysinternals/|\"php/|\"nerd-fonts/|\"nonportable/|\"java/|\"games/', '"scoop-cn/' 

        # 将 depends 路径改为 scoop-cn
        $content = $content -replace '\"depends\":\s*\"(scoop\-cn/)?', '"depends": "scoop-cn/' 
        Set-Content -Path $_.FullName -Value $content
    } | Format-List -Property TotalMilliseconds
}
# Start: Free Download Manager
# (Get-Content .\bucket\freedownloadmanager.json).Replace('dn3.freedownloadmanager.org', 'files2.freedownloadmanager.org') | Set-Content -Path .\bucket\freedownloadmanager.json

# $JSON = Get-Content .\bucket\freedownloadmanager.json | ConvertFrom-Json

# Invoke-RestMethod $JSON.architecture."64bit".url -Outfile .\fdm_x64_setup.exe
# Invoke-RestMethod $JSON.architecture."32bit".url -Outfile .\fdm_x86_setup.exe

# $JSON.architecture."64bit".hash = (Get-FileHash .\fdm_x64_setup.exe -Algorithm SHA256).Hash.ToLower()
# $JSON.architecture."32bit".hash = (Get-FileHash .\fdm_x86_setup.exe -Algorithm SHA256).Hash.ToLower()

# $JSON | ConvertTo-Json -Depth 4 | Set-Content -Path .\bucket\freedownloadmanager.json

# Remove-Item -Path .\fdm_x64_setup.exe
# Remove-Item -Path .\fdm_x86_setup.exe
# End: Free Download Manager

