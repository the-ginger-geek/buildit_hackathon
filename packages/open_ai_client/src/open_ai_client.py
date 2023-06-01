import openai
import argparse

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

def main():
    # Set up argument parser
    parser = argparse.ArgumentParser(description='Ask OpenAI API.')
    parser.add_argument('--api_key', type=str, required=True,
                        help='Your OpenAI API key')
    parser.add_argument('--questions', metavar='Q', type=str, nargs='+', required=True,
                        help='a question for the OpenAI API')

    # Parse arguments
    args = parser.parse_args()

    # Call ask_openai with API key and questions from arguments
    response = ask_openai(args.api_key, args.questions)
    print(response)

if __name__ == "__main__":
    main()