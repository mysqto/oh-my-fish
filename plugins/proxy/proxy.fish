function proxy -d "Setup proxy environment variables"

  if not set -q proxy_auth
    echo "Note: proxy_auth not set for proxies need username and password, no auth for proxy"
    echo "If you are using a proxy need auth, please set proxy_auth to yes in config.fish"
    set proxy_auth no
  end

  switch $proxy_auth

    case yes

      if not set -q proxy_host
        echo "Error: You must set proxy_host to your proxy hostname:port in config.fish"
        echo "You may also set proxy_user to your username"
        return
      end

      # Get user & password
      set -l user $proxy_user
      if not set -q proxy_user
        read -p "echo -n 'Proxy User: '" user
      end

      # Hacky way to read password in fish
      echo -n 'Proxy Password: '
      stty -echo
      head -n 1 | read -l pass
      stty echo
      echo

      # URL encode password
      set -l chars (echo $pass | sed -E -e 's/./\n\\0/g;/^$/d;s/\n//')
      printf '%%%02x' "'"$chars"'" | read -l encpass

      # Set system proxy
      _proxy_set "http://$user:$encpass@$proxy_host"

    case '*'

      _proxy_set "http://$proxy_host"

  end	# end switch case
end	# end function proxy
