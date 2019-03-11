resource "random_id" "project" {
  count       = var.project_id == null ? 1 : 0
  byte_length = 2
}

resource "packet_project" "project" {
  count = var.project_id == null ? 1 : 0
  name  = "jmeter-perf-tests-${random_id.project[count.index].hex}"
}

resource "random_id" "jmeter" {
  count       = var.instance_count
  byte_length = 2
}

resource "packet_device" "jmeter" {
  count            = var.instance_count
  project_id       = var.project_id == null ? packet_project.project[0].id : var.project_id
  hostname         = "tf-jmeter-${random_id.jmeter[count.index].hex}"
  plan             = "t1.small.x86"
  facilities       = ["ewr1"]
  operating_system = "centos_7"
  billing_cycle    = "hourly"

  provisioner "remote-exec" {
    inline = [
      <<EOF
set -eux

sudo yum install -y -q java bc

curl -s https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-5.0.tgz > apache-jmeter-5.0.tgz
tar xzf apache-jmeter-5.0.tgz
cd apache-jmeter-5.0

curl -s 'http://search.maven.org/remotecontent?filepath=kg/apc/jmeter-plugins-manager/1.3/jmeter-plugins-manager-1.3.jar' > lib/ext/jmeter-plugins-manager-1.3.jar
curl -s http://search.maven.org/remotecontent?filepath=kg/apc/cmdrunner/2.2/cmdrunner-2.2.jar > lib/cmdrunner-2.2.jar

java -cp lib/ext/jmeter-plugins-manager-1.3.jar org.jmeterplugins.repository.PluginManagerCMDInstaller

echo 'export PATH=$PATH:$HOME/apache-jmeter-5.0/bin' >> ~/.bashrc

./bin/PluginsManagerCMD.sh upgrades

sudo sysctl net.ipv4.tcp_tw_recycle=1
sudo sysctl net.ipv4.tcp_fin_timeout=1
sudo sysctl net.ipv4.ip_local_port_range="18000 65535"
EOF
    ]

    connection {
      type = "ssh"
      user = "root"
      host = self.network[0].address
    }
  }

  provisioner "local-exec" {
    command = "ssh-keygen -R ${self.network[0].address}"
  }

  provisioner "local-exec" {
    command = "ssh-keyscan ${self.network[0].address} >> ~/.ssh/known_hosts"
  }
}
