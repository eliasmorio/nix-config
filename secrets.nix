{
  # Secrets definitions for thinkserver1
  # Run: ./scripts/encrypt-secret.sh <name> <value> [age-public-key]
  
  wg0-private = {
    file = ../secrets/wg0-private.age;
    owner = "root";
    group = "root";
    mode = "600";
  };
}