require 'yaml'
settings = YAML.load_file(File.dirname(__FILE__) + '/settings.yml')

Vagrant.configure("2") do |config|

    config.vm.box = "robertweiss/pwbox"
    config.vm.box_version = "1.1"
    config.vm.provider "virtualbox"

    config.vm.hostname = settings['domain']

    config.vm.network "forwarded_port", guest: 80, host: 8080
    config.vm.network "private_network", ip: "192.168.33.10"

    config.vm.synced_folder ".", "/var/www", :nfs => { :mount_options => ["dmode=777","fmode=666"] }

    config.vm.provision "shell", :path=> "./scripts/install.sh", :keep_color=> true, :args=> [settings['title'], settings['name'], settings['domain']]

    config.vm.provision "file", :source=> "~/ownCloud/Pro-Modules/", :destination=> "/var/www/public/site/modules"

    config.vm.provision "shell", :path=> "./scripts/postinstall_client.sh", :keep_color=> true

    config.vm.provision "trigger" do |trigger|
        trigger.fire do
            run "./scripts/postinstall_host.sh '" + settings['title'] + "' '" + settings['name'] + "' '" + settings['domain'] + "'"
        end
    end

    config.trigger.before [:suspend, :halt, :destroy] do
        info "Dumping database"
        run_remote "mysqldump -u root -proot " + settings['name'] + " > /var/www/" + settings['name'] + ".sql"
      end
end
