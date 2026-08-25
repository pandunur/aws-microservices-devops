from flask import Flask, jsonify

app = Flask(__name__)


@app.route("/health")
def health():
    return jsonify({
        "service": "payment-service",
        "status": "healthy"
    })


@app.route("/payments")
def payments():
    return jsonify({
        "service": "payment-service",
        "payments": [
            {
                "id": 1001,
                "status": "completed"
            },
            {
                "id": 1002,
                "status": "pending"
            }
        ]
    })


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)
