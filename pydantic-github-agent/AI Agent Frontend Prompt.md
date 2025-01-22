**Lovable/Bolt Prompt for our AI Agent Frontend**

Create a beautiful dark theme chat interface (dark blue and gray colors) for me to talk to my AI agent which is hosted with FastAPI. The URL for the agent is **http://localhost:8001/api/pydantic-github-agent**. 

**The request schema is set up like this:**

*class AgentRequest(BaseModel):*   
    *query: str*   
    *user\_id: str*   
    *request\_id: str*   
    *session\_id: str*

So you need to provide all of these in the POST request payload.

* query: The user's latest message to the agent   
* user\_id: We won't set up authentication right now so this can be "NA"   
* request\_id: A unique UUID for the request   
* session\_id: The UUID of the conversation. Generate one for any new conversation 

**The response from the AI agent is simply:**

*class AgentResponse(BaseModel):*   
    *success: bool*

And that is because the user and AI messages are stored in a realtime Supabase table in the API so nothing is returned to the frontend besides the success (true or false). So you need to set up the Supabase client to wait for updates in realtime to add new messages to the conversation in the frontend.

SUPABASE_URL="["https://tmckhfloennrdxkqescf.supabase.co"]"

SUPABASE_SERVICE_KEY="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRtY2toZmxvZW5ucmR4a3Flc2NmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzc1MTgzMDQsImV4cCI6MjA1MzA5NDMwNH0.KtXNHcayCF1ujP2rn23ax0AwQBfQscwoy9PMZFv8ORU

Don’t ask me to configure Supabase, just use the above URL and public key in the code.

**The messages table schema is:**

*CREATE TABLE messages (*  
    *id uuid DEFAULT gen\_random\_uuid() PRIMARY KEY,*   
    *created\_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT\_TIMESTAMP,*   
    *session\_id TEXT NOT NULL,*   
    *message JSONB NOT NULL*   
*);*

Where the content in each message is message.content and the type is message.type (either ‘human’ or ‘ai’)

**I want these features for the chat:**

* Loading indicator when getting response from the agent   
* Auto scroll to the bottom to reveal new messages   
* Conversation bar on the left side that is collapsible. Get all the conversations by fetching the unique session IDs from the messages table, and using the first 100 characters of the first user message from the conversation as the title.   
* Handle markdown for the AI responses

Also have the home page by Supabase authentication with email and password.

