import json

# Load the JSON file
with open('file.json') as file:
    data = json.load(file)

# Iterate over each object in the JSON array
for obj in data:
    max_bounty = obj['max_bounty']['value']
    min_bounty = obj['min_bounty']['value']

    # Check if max_bounty or min_bounty is not equal to 0
    if max_bounty != 0 or min_bounty != 0:
        handle = obj['handle']
        in_scope_endpoints = [endpoint['endpoint'] for endpoint in obj['targets']['in_scope'] if endpoint['type'] == 'url']
        out_of_scope_endpoints = [endpoint['endpoint'] for endpoint in obj['targets']['out_of_scope'] if endpoint['type'] == 'url']

        if in_scope_endpoints or out_of_scope_endpoints:
            print(f"bbrf new \"{handle}\"")
            print(f"bbrf use \"{handle}\"")

            for endpoint in in_scope_endpoints:
                print(f"bbrf inscope add {endpoint}")

            for endpoint in out_of_scope_endpoints:
                print(f"bbrf outscope add {endpoint}")

            print()
