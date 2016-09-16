#Side loads channel to roku device through curl.
#author : Seiji Morikami

require "fileutils"
require "date"
require "tempfile"

$roku_ip_address = "10.0.1.23"

#update manifest version.
def roku_update_manifest(path)

	build_version = ""

	temp_file = Tempfile.new('manifest')
	begin
		File.open(path, 'r') do |file|
			file.each_line do |line|
				if line.include?("build_version")

					#Update build version.
					build_version = line.split(".")
					iteration = 0
					if 2 == build_version.length
						iteration = build_version[1].to_i + 1
						build_version[0] = Time.now.strftime("%m%d%y")
						build_version[1] = iteration
						build_version = build_version.join(".")
					else
						#Use current date.
						build_version = Time.now.strftime("%m%d%y")+".1"
					end
					temp_file.puts "build_version=#{build_version}"

				else
					temp_file.puts line
				end
			end
		end
	  temp_file.rewind
	  FileUtils.cp(temp_file.path, path)
	ensure
	  temp_file.close
	  temp_file.unlink
	end
end

# side load to roku device with curl
def roku_side_load
	puts "packaging to: #{$roku_ip_address}"
	puts "Zipping package..."
	puts "changing folder - " + Dir.pwd

	system("zip -r  pkg.zip \"components\" >> pkg_log.txt")
	system("zip -r  pkg.zip \"resources\" >> pkg_log.txt")
	system("zip -r  pkg.zip \"images\" >> pkg_log.txt")
	system("zip -r  pkg.zip \"manifest\" >> pkg_log.txt")
  system("zip -r  pkg.zip \"adbmobileconfig.json\" >> pkg_log.txt")
	system("zip -r  pkg.zip \"source\" >> pkg_log.txt")
	system("rm pkg_log.txt")
	system("rm pkg.zip.tmp*")
	package_success = false
	package_message = "No package created!"
	puts "Sending package to roku device..."
	package_pipe = IO.popen("curl --anyauth -u \"rokudev:aaaa\" --digest -s -S -F \"archive=@pkg.zip\" -F \"mysubmit=Replace\" http://#{$roku_ip_address}/plugin_install")
	while(line = package_pipe.gets)
		if line.include?("Application Received")
			package_message = line
		end
		if line.include?("Install Success")
			package_success = true
		end
	end
	system("rm pkg.zip")
	system("rm pkg_log.txt")
	puts "Result: " + package_message
end

if 2 == ARGV.length
	$roku_ip_address = ARGV[1]
	if "r" == ARGV[0]
		roku_update_manifest("#{Dir.pwd}/manifest")
	end
	roku_side_load
elsif 1 == ARGV.length
	if "r" == ARGV[0]
		roku_update_manifest("#{Dir.pwd}/manifest")
	end
	roku_side_load
end
