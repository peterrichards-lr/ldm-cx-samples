const express = require('express');
const app = express();
const port = 8080;

app.use(express.json());

app.post('/workflow-action', (req, res) => {
  console.log('Received Workflow Action payload:');
  console.log(JSON.stringify(req.body, null, 2));
  
  res.status(200).send({
    message: 'Workflow Action processed successfully'
  });
});

app.listen(port, () => {
  console.log(`Sample Workflow Action extension listening at http://localhost:${port}`);
});
