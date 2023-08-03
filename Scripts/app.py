from flask import Flask, request, jsonify, make_response
from flask_jwt_extended import JWTManager, jwt_required, create_access_token, get_jwt_identity
from flask_cors import CORS
import datetime
from flask import Flask
from flask_mysqldb import MySQL
import pymysql
# Read from environment variables
import os


app = Flask(__name__)
CORS(app)  # Enable Cross-Origin Resource Sharing (CORS) to allow communication with the Flutter front-end

# Replace this secret key with your own random secret key for JWT token encryption
app.config['JWT_SECRET_KEY'] = 'FTtur1PvbwHP1uFbQLmL2OsH4ql2MkfCFoWYZ8sT-d4xbcBT7AAOnQJyysu-S_oJmdZTYOq2tOJDT8z9oD-xGA'
app.config['JWT_ACCESS_TOKEN_EXPIRES'] = datetime.timedelta(hours=24)  # Token expiration time (1 hour in this case)
jwt = JWTManager(app)

# MySQL configurations
app.config['MYSQL_DATABASE_HOST'] = os.environ['MYSQL_DATABASE_HOST']
app.config['MYSQL_DATABASE_USER'] = os.environ['MYSQL_DATABASE_USER']
app.config['MYSQL_DATABASE_PASSWORD'] = os.environ['MYSQL_DATABASE_PASSWORD']
app.config['MYSQL_DATABASE_DB'] = os.environ['MYSQL_DATABASE_DB']


print("Printing config")
print(app.config)
# mysql = MySQL(app)
def create_db_connection():
    return pymysql.connect(
        host=app.config['MYSQL_DATABASE_HOST'],
        user=app.config['MYSQL_DATABASE_USER'],
        password=app.config['MYSQL_DATABASE_PASSWORD'],
        db=app.config['MYSQL_DATABASE_DB'],
        ssl={'ssl': {'ca': 'ssl/DigiCertGlobalRootCA.crt.pem'}} 
    )

# User registration API
@app.route('/api/register', methods=['POST'])
def register():
    data = request.get_json()
    email = data['email']
    password = data['password']
    name = data['name']
    print(name);

    # Check if user already exists in the database
    conn = create_db_connection()
    cursor = conn.cursor()
    cursor.execute('SELECT * FROM users WHERE email = %s', (email,))
    user = cursor.fetchone()
    if user:
        cursor.close()
        conn.close()
        return jsonify(message='User already exists'), 409

    # Save the new user to the database
    cursor.execute('INSERT INTO users (email, password, name) VALUES (%s, %s, %s)', (email, password, name))
    conn.commit()
    cursor.close()
    conn.close()
    access_token = create_access_token(identity=email)
    return jsonify(message='User registered successfully', token=access_token), 201

# User login API
@app.route('/api/login', methods=['POST'])
def login():
    data = request.get_json()
    email = data['email']
    password = data['password']

    # Check if user exists and password matches
    conn = create_db_connection()
    cursor = conn.cursor()
    cursor.execute('SELECT * FROM users WHERE email = %s AND password = %s', (email, password))
    user = cursor.fetchone()
    if user:
        access_token = create_access_token(identity=email)
        print("if statement")
        cursor.close()
        conn.close()
        return jsonify(token=access_token, name=user[2]), 200
    else:
        cursor.close()
        conn.close()
        return jsonify(message='Invalid email or password'), 401

# Scavenger hunt tasks API
@app.route('/api/tasks', methods=['GET'])
@jwt_required()  # Protect this route with JWT authentication
def get_tasks():
    conn = create_db_connection()
    cursor = conn.cursor()
    cursor.execute('SELECT * FROM tasks')
    tasks = cursor.fetchall()
    cursor.close()
    conn.close()

    return jsonify(tasks), 200

@app.route('/api/test_connection', methods=['GET'])
def test_connection():
    try:
        conn = create_db_connection()
        cursor = conn.cursor()
        cursor.execute('SELECT * FROM tasks')
        tasks = cursor.fetchall()
        cursor.close()
        conn.close()

        return jsonify(tasks), 200
    except Exception as e:
        return jsonify(error=str(e)), 500
    
# API to store a new chat message
# API to store a new chat message
@app.route('/api/chat', methods=['POST'])
def add_chat_message():
    conn = create_db_connection()
    event_id = request.json['event_id']
    sender_id = request.json['sender_id']
    message = request.json['message']

    cursor = conn.cursor()
    cursor.execute("INSERT INTO chat_messages (event_id, sender_id, message) VALUES (%s, %s, %s)", (event_id, sender_id, message))
    conn.commit()
    cursor.close()

    return jsonify({"message": "Chat message added successfully."}), 201

# API to retrieve chat messages for a specific event
@app.route('/api/chat/<int:event_id>', methods=['GET'])
def get_chat_messages(event_id):
    conn = create_db_connection()
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM chat_messages WHERE event_id = %s ", (event_id,))
    messages = cursor.fetchall()
    cursor.close()

    return jsonify(messages), 200



if __name__ == '__main__':
    app.run(debug=True)
