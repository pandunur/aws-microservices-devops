from flask import Flask, jsonify

app = Flask(__name__)


@app.route("/health")
def health():
    return jsonify({
        "service": "notification-service",
        "status": "healthy"
    })


@app.route("/notifications")
def notifications():
    return jsonify({
        "service": "notification-service",
        "notifications": [
            {
                "id": 1,
                "message": "Payment successful"
            },
            {
                "id": 2,
                "message": "Welcome to the platform"
            }
        ]
    })


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)
