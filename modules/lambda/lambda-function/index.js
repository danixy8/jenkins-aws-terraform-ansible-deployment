const AWS = require('aws-sdk');
const ec2 = new AWS.EC2();

exports.handler = async (event) => {
  const { action } = event.queryStringParameters;
  const { password } = JSON.parse(event.body || '{}');

  try {
    if (!password || password !== process.env.PASSWORD) {
      return {
        statusCode: 400,
        body: JSON.stringify({ error: 'El parámetro "password" es requerido o no es válido' }),
      };
    }
    let response;
    switch (action) {
      case 'stop':
        response = await ec2.stopInstances({ InstanceIds: [process.env.INSTANCE_IP] }).promise();
        break;
      case 'start':
        response = await ec2.startInstances({ InstanceIds: [process.env.INSTANCE_IP] }).promise();
        break;
      case 'status':
        const data = await ec2.describeInstances({ InstanceIds: [process.env.INSTANCE_IP] }).promise();
        const instanceName = data.Reservations[0].Instances[0].KeyName;
        const instanceType = data.Reservations[0].Instances[0].InstanceType;
        const PublicIpAddress = data.Reservations[0].Instances[0].PublicIpAddress
        const state = data.Reservations[0].Instances[0].State.Name;
        // response = data.Reservations[0].Instances[0]
        response = { instanceName, instanceType, state, JenkinsURL: `http://${PublicIpAddress}:8080/` };
        break;
      default:
        response = { message: 'Acción no válida' };
    }

    return {
      statusCode: 200,
      body: JSON.stringify(response),
    };
  } catch (err) {
    return {
      statusCode: 500,
      body: JSON.stringify({ error: err.message }),
    };
  }
};