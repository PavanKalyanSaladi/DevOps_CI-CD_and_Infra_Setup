from flask import Flask, render_template, jsonify, session, request, redirect, url_for
from datetime import datetime, timedelta
from prometheus_flask_exporter import PrometheusMetrics

app = Flask(__name__)
app.secret_key = 'devops-secret-key'  # Needed for session
metrics = PrometheusMetrics(app)

@app.route('/')
def home():
    orders = session.get('orders', [])
    return render_template('index.html', orders=orders)

@app.route('/order', methods=['POST'])
def order():
    orders = session.get('orders', [])
    now = datetime.now()
    delivery_time = now + timedelta(minutes=25)
    order = {
        'placed_at': now.strftime('%Y-%m-%d %H:%M:%S'),
        'delivery_at': delivery_time.strftime('%Y-%m-%d %H:%M:%S')
    }
    orders.append(order)
    session['orders'] = orders
    return jsonify({"message": "Your order has been placed!", "orders": orders})

@app.route('/health')
def health():
    return jsonify(status="ok"), 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
