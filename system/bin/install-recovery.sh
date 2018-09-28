#!/system/bin/sh
if ! applypatch -c EMMC:/dev/block/platform/soc/7824900.sdhci/by-name/recovery:13061354:fc4e6c025b82170298a4b4af74f04d68caed8505; then
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/platform/soc/7824900.sdhci/by-name/boot:10736870:c0f1301510615607d8285ab5fe1abf23b757fca1 EMMC:/dev/block/platform/soc/7824900.sdhci/by-name/recovery fc4e6c025b82170298a4b4af74f04d68caed8505 13061354 c0f1301510615607d8285ab5fe1abf23b757fca1:/system/recovery-from-boot.p && log -t recovery "Installing new recovery image: succeeded" || log -t recovery "Installing new recovery image: failed"
else
  log -t recovery "Recovery image already installed"
fi
