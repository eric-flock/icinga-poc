require 'fileutils'

def repo_list
  # Install required packages
  system("apt -y install apt-transport-https wget gnupg")
  
  # Download the Icinga key
  system("wget -O - https://packages.icinga.com/icinga.key | gpg --dearmor -o /usr/share/keyrings/icinga-archive-keyring.gpg")
  
  # Source the os-release file
  os_release = {}
  File.readlines('/etc/os-release').each do |line|
    key, value = line.strip.split('=')
    os_release[key] = value.tr('"', '')
  end

  # Determine the distribution codename
  dist = if os_release["UBUNTU_CODENAME"]
    os_release["UBUNTU_CODENAME"]
  else
    `lsb_release -c | awk '{print $2}'`.strip
  end

  # Write the repository details
  repo_file = "/etc/apt/sources.list.d/#{dist}-icinga.list"
  keyring_path = "/usr/share/keyrings/icinga-archive-keyring.gpg"

  File.open(repo_file, 'w') do |file|
    file.puts "deb [signed-by=#{keyring_path}] https://packages.icinga.com/ubuntu icinga-#{dist} main"
    file.puts "deb-src [signed-by=#{keyring_path}] https://packages.icinga.com/ubuntu icinga-#{dist} main"
  end
end

repo_list