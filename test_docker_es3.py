import subprocess

def run_command(command):
    try:
        result = subprocess.run(command, shell=True, text=True, capture_output=True)
        return result.stdout.strip(), result.stderr.strip()
    except Exception as e:
        return "", str(e)

def check_containers():
    output, error = run_command("docker ps --format '{{.Names}}'")
    if error:
        print(f"Error: {error}")
    else:
        print(f"Containers:\n{output}")

def test_connectivity():
    print("\nTesting connectivity...")

    tests = [
        ("client", "ping -c 3 google.com"),  # Test di accesso a Internet
        ("docker_es3-traefik-1", "ping -c 3 facebook.com"),  # Test di accesso a Internet
        ("client", "nc -zv docker_es3-db-server-1 3306"),  # Test connessione al DB
        ("firewall_mz", "ufw status verbose"),  # Stato del firewall MZ
        ("firewall_dmz", "ufw status verbose"),  # Stato del firewall DMZ
        ("docker_es3-db-server-1", "mysqladmin ping -h localhost -u user --password=password"),  # Test MySQL
    ]

    for container, command in tests:
        print(f"\nTesting in: {container}, Command: {command}")
        output, error = run_command(f"docker exec -it {container} sh -c '{command}'")
        if error:
            print(f"Error: {error}")
        else:
            print(f"Output:\n{output}")

if __name__ == "__main__":
    check_containers()
    test_connectivity()
