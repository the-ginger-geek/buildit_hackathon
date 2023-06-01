import openai
import argparse
import glob
import csv
import requests
import io

def ask_openai(api_key, questions):
    openai.api_key = api_key
    print("apikey: ", api_key)

    messages = [
        {"role": "system", "content": "You are a knowledgeable programming assistant."},
    ]

    # Add each user question to the messages
    for question in questions:
        messages.append({"role": "user", "content": question})

    response = openai.ChatCompletion.create(
        model="gpt-3.5-turbo",
        messages=messages
    )

    return response['choices'][0]['message']['content']

def build_questions(directory, org_slug, project_slug, auth_token):
    questions = ["Scan through the following code"]
    for filepath in glob.iglob(f'{directory}/**/*.dart', recursive=True):
        with open(filepath, 'r') as file:
            questions.append(file.read())
    questions.append("Now look at the logs that follow and determine where the bug in the code lies")
    
    events = get_sentry_events(org_slug, project_slug, auth_token)
    if events is not None:
        events_string = write_events_to_string(events)
        questions.append(events_string)
    return questions


def get_sentry_events(organization_slug, project_slug, auth_token):
    url = f"https://sentry.io/api/0/projects/{organization_slug}/{project_slug}/events/"
    headers = {'Authorization': f'Bearer {auth_token}'}
    try:
        response = requests.get(url, headers=headers)
        response.raise_for_status()  # This will raise a HTTPError if the response was unsuccessful
    except requests.exceptions.RequestException as err:
        print(f"Error occurred: {err}")
        return None  # Or however you want to handle this
    else:
        return response.json()


def write_events_to_string(events):
    output = io.StringIO()
    fieldnames = ['eventID', 'dateCreated', 'message', 'tags']
    writer = csv.DictWriter(output, fieldnames=fieldnames)
    writer.writeheader()
    for event in events:
        tags = {tag['key']: tag['value'] for tag in event.get('tags', [])}
        writer.writerow({
            'eventID': event['eventID'],
            'dateCreated': event['dateCreated'],
            'message': event['message'],
            'tags': tags,
        })
    return output.getvalue()

def main():
    # Set up argument parser
    parser = argparse.ArgumentParser(description='Ask OpenAI API.')
    parser.add_argument('--api_key', type=str, required=True,
                        help='Your OpenAI API key')
    parser.add_argument('--directory', type=str, required=True,
                        help='Directory containing .dart files')
    parser.add_argument('--sentry_auth_token', type=str, required=True, help='Your Sentry auth token')
    parser.add_argument('--org_slug', type=str, required=True, help='The slug of your organization')
    parser.add_argument('--project_slug', type=str, required=True, help='The slug of your project')


    # Parse arguments
    args = parser.parse_args()

    # Get the contents of the .dart files
    questions = build_questions(args.directory, args.org_slug, args.project_slug, args.sentry_auth_token)

    # Call ask_openai with API key and questions from arguments
    response = ask_openai(args.api_key, questions)
    print(response)

if __name__ == "__main__":
    main()