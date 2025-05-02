#!/bin/bash

# Step 1: Ask for OpenAI API Key
read -p "Enter your OpenAI API Key: " api_key

# Step 2: Install Python and pip if missing
sudo apt update
sudo apt install -y python3 python3-pip

# Step 3: Install required Python package
pip3 install openai

# Step 4: Export API key to environment
echo "export OPENAI_API_KEY=$api_key" >> ~/.bashrc
export OPENAI_API_KEY=$api_key

# Step 5: Create Python script
cat << 'EOF' > chatgpt_cmd.py
import os
import openai

openai.api_key = os.getenv("OPENAI_API_KEY")

chat_history = []

print("ChatGPT Terminal. Type 'exit' to quit.\n")

while True:
    user_input = input("You: ")
    if user_input.lower() in ['exit', 'quit']:
        break

    chat_history.append({"role": "user", "content": user_input})

    try:
        response = openai.ChatCompletion.create(
            model="gpt-3.5-turbo",
            messages=chat_history
        )
        reply = response['choices'][0]['message']['content'].strip()
        print("ChatGPT:", reply)
        chat_history.append({"role": "assistant", "content": reply})
    except Exception as e:
        print("Error:", e)
EOF

# Step 6: Run the script
python3 chatgpt_cmd.py
