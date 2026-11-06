from pathlib import Path
from flask import Flask, request, jsonify
from flask_cors import CORS
import sqlite3
from werkzeug.security import generate_password_hash, check_password_hash
app = Flask(__name__)
cors = CORS(app, resources={r"/api/*": {"origins": "*"}})

babyshop_dir = Path(__file__).resolve().parent # get the total file directory
schema_file = babyshop_dir / 'schema.sql'
db_file = babyshop_dir / 'babyshop.db'
product_seed = babyshop_dir / 'productseed.sql'


def init_db():
    conn = sqlite3.connect(str(db_file))
    cursor = conn.cursor()
    
    try:
        sqlfile = schema_file.read_text()

        cursor.executescript(sqlfile)
        conn.commit()
        print(f'Database has been created from: {db_file}')


    except FileNotFoundError:
        print(f'Error: {schema_file} file not found.')
    finally:
        conn.close()

@app.route("/")
def home():
    return "<h1>BabyShopHub Backend</h1>"

#SIGN UP PAGE API
@app.route("/api/signup", methods=['POST'])
def receive_input():
    data = request.get_json()

    if not data:
        return jsonify({'error': 'Missing or invalid JSON data'}), 400

    first_name = data.get('first_name')
    email = data.get('email')
    password = data.get('password')

    if not first_name or not email or not password:
        return jsonify({'error': 'Missing required fields'}), 400

    # initialising the database again in the app.route
    conn = None
    try:
        conn = sqlite3.connect(str(db_file)) # storing the database file
        cursor = conn.cursor() # storing the execution of the databse file in python

        hashed_password = generate_password_hash(password) # hashes the password value recieved and stores it in a new variable
        QUERY = ''' INSERT INTO Users (first_name, email, password_hash) VALUES (?,?,?)'''
        
        cursor.execute(QUERY, (first_name,email,hashed_password)) # executes the storing of the values

        conn.commit() # commit the changes to the databse file

        return jsonify({'message': 'Account has been cretaed'}), 201

    except sqlite3.IntegrityError:
        return jsonify({'error': 'An account with this email already exists'}), 400
    finally:
        if conn is not None:
          conn.close() # close the databse file after changes

#LOGIN PAGE API
@app.route("/api/login", methods=['POST'])
def login():
    data = request.get_json() # request json

    if not data:
        return jsonify({'error': 'Missing JSON payload'}), 400
    
    email = data.get('email')
    password = data.get('password')

    if not email or not password:
        return jsonify({'error': 'Email and password are required'}),400

    conn = None
    try:
        conn = sqlite3.connect(str(db_file))
        cursor = conn.cursor()

        QUERY = '''SELECT id,first_name,email,password_hash FROM Users WHERE email = ?'''
        cursor.execute(QUERY,(email,))
        user = cursor.fetchone()

        if not user or not check_password_hash(user[3], password):
            return jsonify({'error': 'Invalid email or password'}), 401
        
        return jsonify({
            'status': 'success',
            'user': {
                'id': user[0],
                'name': user[1],
                'email': user[2],
            }
        }), 200

    except sqlite3.Error:
        return jsonify({'error': 'Database connection error'}),500
    
    finally:
        if conn is not None:
            conn.close()

#PRODUCTS API
@app.route("/api/products", methods=['GET'])
def get_products ():
    conn = sqlite3.connect(str(db_file))
    conn.row_factory = sqlite3.Row
    cursor = conn.cursor()

    cursor.execute("SELECT * FROM Products ORDER BY RANDOM()")
    products_data = cursor.fetchall()
    products_list = []

    for row in products_data:
        products_list.append(dict(row))
    
    conn.close()
    return jsonify(products_list)

if __name__ == '__main__':
    init_db()
    app.run(debug=True, host='0.0.0.0', port=5000)