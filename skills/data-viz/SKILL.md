---
name: data-viz
description: "Generate charts, graphs, dashboards and data visualizations using Node.js (chart.js, d3, canvas) and Python (matplotlib, seaborn, plotly)."
metadata:
  {
    "openclaw":
      {
        "emoji": "📊",
        "requires": { "bins": ["node", "python3"] },
      },
  }
---

# Data Visualization

Use the following tools to create data visualizations from any data source.

## Quick Charts (Node.js)

```bash
npx -y quickchart-js --width 800 --height 400 --config '{
  type: "bar",
  data: {
    labels: ["Jan","Feb","Mar"],
    datasets: [{label: "Sales", data: [30,45,38]}]
  }
}' --output /tmp/chart.png
```

## Python (matplotlib)

```bash
python3 -c "
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import json

# Load data
data = json.load(open('/tmp/data.json'))

fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(12, 5))
ax1.bar(data['labels'], data['values'])
ax1.set_title('Bar Chart')
ax2.plot(data['labels'], data['values'], marker='o')
ax2.set_title('Line Chart')
plt.tight_layout()
plt.savefig('/tmp/chart.png', dpi=150)
print('Chart saved to /tmp/chart.png')
"
```

## HTML Dashboards

Create a standalone HTML dashboard with embedded charts:
```bash
cat > /tmp/dashboard.html << 'EOF'
<!DOCTYPE html>
<html><head>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<style>body{font-family:sans-serif;padding:20px;max-width:1200px;margin:auto}</style>
</head><body>
<h1>Project Dashboard</h1>
<canvas id="chart1" height="200"></canvas>
<script>
new Chart(document.getElementById('chart1'), {
  type: 'bar',
  data: {
    labels: ['Open','In Progress','Review','Done'],
    datasets: [{label: 'Tasks', data: [5, 3, 2, 8]}]
  }
});
</script></body></html>
EOF
echo "Dashboard: /tmp/dashboard.html"
```

## CSV Data Analysis

```bash
# Quick stats with Python
python3 -c "
import csv, json, sys
with open('/tmp/data.csv') as f:
    reader = csv.DictReader(f)
    rows = list(reader)
print(json.dumps({k: [float(r[k]) for r in rows if r[k]] for k in reader.fieldnames}, indent=2))
"
```
