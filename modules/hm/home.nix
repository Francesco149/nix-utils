{
  imports,
  user,
}:
{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.${user} = {
      inherit imports;
    };
  };
}
