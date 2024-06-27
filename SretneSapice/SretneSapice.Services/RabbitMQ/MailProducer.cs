using Newtonsoft.Json;
using RabbitMQ.Client;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SretneSapice.Services.RabbitMQ
{
    public class MailProducer : IMailProducer
    {

        public void SendEmail<T>(T message) { 
                var factory = new ConnectionFactory
                {
                    HostName = "localhost",
                    Port = 5672,
                    UserName = "user",
                    Password = "password",
                };
                factory.ClientProvidedName = "Rabbit Test";

                IConnection connection = factory.CreateConnection();
                IModel channel = connection.CreateModel();

                string exchangeName = "EmailExchange";
                string routingKey = "email_queue";
                string queueName = "EmailQueue";

                channel.ExchangeDeclare(exchangeName, ExchangeType.Direct);
                channel.QueueDeclare(queueName, true, false, false, null);
                channel.QueueBind(queueName, exchangeName, routingKey, null);

                string emailModelJson = JsonConvert.SerializeObject(message);
                byte[] messageBodyBytes = Encoding.UTF8.GetBytes(emailModelJson);
                channel.BasicPublish(exchangeName, routingKey, null, messageBodyBytes);
            
        }
    }
}
