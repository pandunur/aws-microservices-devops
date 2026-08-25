from flask import Flask, jsonify

app = Flask(__name__)


@app.route("/health")
def health():
    return jsonify({
        "service": "user-service",
        "status": "healthy"
    })


@app.route("/users")
def users():
    return jsonify({
        "service": "user-service",
        "users": [
            {
                "id": 1,
                "name": "Pandu"
            },
            {
                "id": 2,
                "name": "Alice"
            }
        ]
    })


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)
