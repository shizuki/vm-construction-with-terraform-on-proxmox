# vm-construction-with-terraform-on-proxmox
  
## Telmate/terraform-provider-proxmox を使った時の記録

注意：
- terraform apply した後同一ディレクトリでterraform applyする時は、terraform-plugin-proxmox.log  terraform.tfstateを削除しておかないとdestroyされるので注意

### 変数
- 環境変数に定義しておくもの
  - `PM_PASS`  
    proxmox上でterraformに定義した動作を実行するユーザーのパスワード  
    `TF_VAR_`を付けなくても読み込んで使用してくれる
- `*.tfvars`ファイルで定義するもの
  - `pve_user`  proxmox上でterraformに定義した動作を実行するユーザー名
  - `pve_host`  proxmox上ホストのアドレス
  - `ssh_user`  クローンしたVMにssh接続するためのユーザー名
  - `tgtnode`  ターゲットのproxmoxノード
  - `clone_from`  クローンするテンプレート名
  - `vm_name`  クローン後のVM名
  - `ipv4_address`  クローン後のVMのIPアドレス
  - `ipv4_gateway`  クローン後のVMのデフォルトゲートウェイ
