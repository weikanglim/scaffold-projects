import os

from flask import Flask, render_template, send_from_directory
import redis

app = Flask(__name__)
r = redis.Redis(host=os.getenv("REDIS_HOST", "localhost"), port=os.getenv("REDIS_PORT", 6379), password=os.getenv("REDIS_PASSWORD"), db=0, decode_responses=True)

@app.route('/favicon.ico')
def favicon():
    return send_from_directory(os.path.join(app.root_path, 'static'),
                          'favicon.ico',mimetype='image/vnd.microsoft.icon')

@app.route("/")
def home():
    r.incr("counter")
    return render_template("home.html")

@app.route("/counter")
def counter():
    return r.get("counter")

if __name__ == "__main__":
    app.run(debug=True)