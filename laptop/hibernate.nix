{ ... }:

{
  # Swap file for hibernate — must be >= RAM size.
  swapDevices = [
    {
      device = "/swapfile";
      size = 32768; # 32 GiB, covers 30 GB RAM
    }
  ];

  # After the first rebuild, /swapfile will exist. Get the resume offset with:
  #   sudo filefrag -v /swapfile | awk 'FNR==4{print $4}' | sed 's/\.\.//'
  # Replace the 0 below with that number, then rebuild again.
  boot.resumeDevice = "/dev/disk/by-uuid/a11fea5e-6717-4fa2-8408-0937ebc8528a";
  boot.kernelParams = [ "resume_offset=44204032" ];

  services.logind = {
    lidSwitch = "hibernate";
    lidSwitchExternalPower = "hibernate";
  };
}
