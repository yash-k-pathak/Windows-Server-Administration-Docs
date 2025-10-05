# 🔗 Configuring iSCSI and MPIO

## 🧠 Objective
To connect servers to iSCSI targets and configure Multipath I/O for redundancy.

## ⚙️ Steps
- Install **iSCSI Initiator** and **MPIO** features.
- Configure target IPs and sessions.
- Enable multiple paths and claim devices for MPIO.

## 🧩 Verification
- Check `mpclaim -s -d` for path info.

## 📝 Notes
Use separate network adapters for each iSCSI path.
