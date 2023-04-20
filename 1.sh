#!/bin/bash

# OpenSSHサーバーをインストールする
sudo apt-get update
sudo apt-get install -y openssh-server

# 公開鍵を取得するユーザー名を入力する
echo "GitHubから公開鍵を取得するユーザー名を入力してください。"
read username

# GitHubから公開鍵を取得する
public_key=$(curl -s https://github.com/$username.keys)

# 公開鍵が取得できたかどうか確認する
if [ -n "$public_key" ]; then
    # SSHディレクトリを作成する
    ssh_dir="/home/$USER/.ssh"
    authorized_keys_file="$ssh_dir/authorized_keys"

    if [ ! -d "$ssh_dir" ]; then
        sudo mkdir -p "$ssh_dir"
        sudo chmod 700 "$ssh_dir"
        sudo chown $USER:$USER "$ssh_dir"
    fi

    if [ ! -f "$authorized_keys_file" ]; then
        sudo touch "$authorized_keys_file"
        sudo chmod 600 "$authorized_keys_file"
        sudo chown $USER:$USER "$authorized_keys_file"
    fi

    # 公開鍵をauthorized_keysファイルに追加する
    echo "$public_key" | sudo tee -a "$authorized_keys_file" > /dev/null

    # SSHサービスを再起動する
    sudo service ssh restart

    echo "公開鍵を登録しました。"
else
    echo "公開鍵が見つかりませんでした。ユーザー名を確認してください。"
fi

# IPアドレスを表示する
ip=$(ip addr show eth0 | grep -Po 'inet \K[\d.]+')
echo "IPアドレスは $ip です。"

