Vagrant.configure("2") do |config|

    projectname = 'base'

    config.vm.box = "robertweiss/pwbox"
    config.vm.provider "virtualbox"

    projectdomain = projectname + ".dev"
    config.vm.hostname = projectdomain

    config.vm.network "forwarded_port", guest: 80, host: 8080
    config.vm.network "private_network", ip: "192.168.33.10"

    config.vm.synced_folder ".", "/var/www", :nfs => { :mount_options => ["dmode=777","fmode=666"] }

    config.vm.provision "shell", :path => "install.sh", :keep_color=> true, :args=> [projectname, projectdomain]

    config.vm.provision "file", :source => "~/ownCloud/Pro-Modules/", :destination => "/var/www/public/site/modules"

    config.trigger.before [:suspend, :halt, :destroy] do
        info "Dumping database"
        run_remote "mysqldump -u root -proot pw > /var/www/" + projectname + ".sql"
      end
end
