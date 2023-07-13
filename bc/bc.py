import json
import re

# Load the JSON file
with open('file.json') as f:
    data = json.load(f)

# Filter the targets based on max_payout not equal to 0
filtered_data = [item for item in data if item['max_payout'] != 0]

# Process each filtered item
for item in filtered_data:
    # Extract the name and URL
    name = item['name']
    url = item['url']
    
    # Extract the endpoint from the URL
    endpoint = re.search(r'(?<=/)[^/]+$', url).group(0)

    # Print the bbrf commands
    print(f'bbrf new "{endpoint}"')
    print(f'bbrf use "{endpoint}"')

    # Extract and print the in_scope targets
    in_scope_targets = item['targets']['in_scope']
    in_scope_targets_list = [target['target'] for target in in_scope_targets if '.' in target['target']]
    in_scope_targets_str = ' '.join(in_scope_targets_list)
    print(f'bbrf inscope add {in_scope_targets_str}')

    # Extract and print the out_of_scope targets
    out_of_scope_targets = item['targets']['out_of_scope']
    out_of_scope_targets_list = [target['target'] for target in out_of_scope_targets if '.' in target['target']]
    out_of_scope_targets_str = ' '.join(out_of_scope_targets_list)
    print(f'bbrf outscope add {out_of_scope_targets_str}')

    # Print an empty line between items
    print()
