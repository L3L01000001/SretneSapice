using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http.Headers;
using System.Net.Http;
using System.Text;
using System.Text.Json;
using System.Threading.Tasks;
using Newtonsoft.Json;
using Microsoft.AspNetCore.Http;
using SretneSapice.Services.Database;

namespace SretneSapice.Services.Clients
{
    public class PaypalClient
    {
        public string Mode { get; }
        public string ClientId { get; }
        public string ClientSecret { get; }

        public string BaseUrl => Mode == "Live"
            ? "https://api-m.paypal.com"
            : "https://api-m.sandbox.paypal.com";

        private readonly HttpClient _httpClient;
        public PaypalClient(string clientId, string clientSecret, string mode)
        {
            ClientId = clientId;
            ClientSecret = clientSecret;
            Mode = mode;
            _httpClient = new HttpClient();
        }
        public async Task<string> GetAccessTokenAsync()
        {
            var request = new HttpRequestMessage(HttpMethod.Post, $"{BaseUrl}/v1/oauth2/token");
            request.Headers.Authorization = new AuthenticationHeaderValue("Basic", Convert.ToBase64String(Encoding.UTF8.GetBytes($"{ClientId}:{ClientSecret}")));

            request.Content = new StringContent("grant_type=client_credentials", Encoding.UTF8, "application/x-www-form-urlencoded");

            HttpResponseMessage response = await _httpClient.SendAsync(request);

            if (response.IsSuccessStatusCode)
            {
                var jsonContent = await response.Content.ReadAsStringAsync();
                var tokenResponse = JsonConvert.DeserializeObject<dynamic>(jsonContent);
                return tokenResponse.access_token;
            }

            throw new Exception("Failed to get PayPal access token.");
        }

        public async Task<string> CreateOrderAsync(decimal total, string returnUrl, string cancelUrl)
        {
            var accessToken = await GetAccessTokenAsync();

            _httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", accessToken);

            var order = new
            {
                intent = "CAPTURE",
                purchase_units = new[]
                {
            new
            {
                amount = new
                {
                    currency_code = "USD",
                    value = total.ToString("F2") 
                }
            }
        },
                application_context = new
                {
                    return_url = returnUrl,
                    cancel_url = cancelUrl,
                    brand_name = "Sretne Sapice",
                    user_action = "PAY_NOW"
                }
            };

            var request = new HttpRequestMessage(HttpMethod.Post, $"{BaseUrl}/v2/checkout/orders")
            {
                Content = new StringContent(JsonConvert.SerializeObject(order), Encoding.UTF8, "application/json")
            };

            var response = await _httpClient.SendAsync(request);

            if (response.IsSuccessStatusCode)
            {
                var jsonContent = await response.Content.ReadAsStringAsync();
                var orderResponse = JsonConvert.DeserializeObject<dynamic>(jsonContent);
                return orderResponse.id;
            }
            else
            {
                var errorContent = await response.Content.ReadAsStringAsync();
                throw new Exception($"Failed to create PayPal order. Response: {errorContent}");
            }
        }

        public async Task<string> CaptureOrder(int orderId)
        {
            var accessToken = await GetAccessTokenAsync();

            _httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", accessToken);

            var request = new HttpRequestMessage(HttpMethod.Post, $"{BaseUrl}/v2/checkout/orders/{orderId}/capture")
            {
                Content = new StringContent("", Encoding.UTF8, "application/json")
            };

            var response = await _httpClient.SendAsync(request);

            if (response.IsSuccessStatusCode)
            {
                var jsonResponse = await response.Content.ReadAsStringAsync();
                var captureOrderResponse = System.Text.Json.JsonSerializer.Deserialize<string>(jsonResponse);
                return captureOrderResponse;
            }
            else
            {
                throw new Exception($"Failed to capture order. StatusCode: {response.StatusCode}");
            }
        }
    }
}
