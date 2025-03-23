{ config, pkgs, ... }:

{
  # Enable printing services
  services.printing.enable = true;
  # Disable PulseAudio in favor of PipeWire
  hardware.pulseaudio.enable = false;
  # Enable RealtimeKit for real-time scheduling
  security.rtkit.enable = true;
  # Configure PipeWire audio server
  services.pipewire = {
    # Enable PipeWire
    enable = true;
    # Enable ALSA support
    alsa.enable = true;
    # Enable 32-bit ALSA support
    alsa.support32Bit = true;
    # Enable PulseAudio compatibility layer
    pulse.enable = true;
  };
}
