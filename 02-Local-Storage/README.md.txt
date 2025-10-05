# 💽 Managing Local Storage

## 🧠 Objective
To create, format, and manage local disks and partitions on Windows Server.

## ⚙️ Steps
- Open **Disk Management** (`diskmgmt.msc`).
- Initialize new disks (MBR/GPT).
- Create and format volumes (NTFS/ReFS).
- Assign drive letters and labels.

## 🧩 Verification
- Run `Get-Volume` in PowerShell to list all drives.

## 📝 Notes
Always label volumes clearly (e.g., Data, Backup, Logs).
