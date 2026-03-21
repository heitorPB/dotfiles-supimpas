# Configuration for K3s, a K8s like system
# Files added to impermanence:
# - /var/lib/rancher
# - .config/helm
# - .config/k9s
# - .kube
# - .cache/helm
{
  lib,
  pkgs,
  ...
}: {
  services.k3s = {
    enable = true;
    role = "server";
    extraFlags = [
      "--docker" # TODO
      #"--container-runtime-endpoint unix:///run/docker.sock" # TODO
      #"--image-service-endpoint unix:///run/docker.sock" # TODO
    ];
  };

  # I don't want K3s starting when the system boots
  systemd.services.k3s.wantedBy = lib.mkForce [];

  # Handy packages
  environment.systemPackages = with pkgs; [
    kubectl
    k9s

    (wrapHelm kubernetes-helm {
      plugins = with pkgs.kubernetes-helmPlugins; [
        helm-diff
      ];
    })
  ];

  # environment.variables = {
  #   KUBECONFIG = "/etc/rancher/k3s/k3s.yaml";
  # };
}
