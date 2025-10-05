# 🧱 Storage Spaces & Data Deduplication

## 🧠 Objective
To pool storage drives and save space with deduplication.

## ⚙️ Steps
- Create a new storage pool and virtual disk.
- Format as NTFS.
- Enable data deduplication role.
- Schedule deduplication jobs.

## 🧩 Verification
- Run `Get-DedupStatus` for space savings.

## 📝 Notes
Best used for file shares, not for running VMs.
