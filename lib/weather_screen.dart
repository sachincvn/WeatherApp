import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'additional_info.dart';
import 'hourly_forecast_item.dart';

class WeatherApp extends StatefulWidget {
  const WeatherApp({super.key});

  @override
  State<WeatherApp> createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  final String city = "Wādi, IN";

  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      var result = await http.get(Uri.parse(
          "https://api.openweathermap.org/data/2.5/forecast?q=$city&APPID=86acbbcd656e50812930b9e5bd2c03a8"));
      var data = jsonDecode(result.body);
      if (data['cod'] != '200') {
        throw 'api called failed, contact admin';
      }
      return data;
    } catch (e) {
      throw 'something went wrong, contact admin';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "weather app",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                setState(() {});
              },
              icon: const Icon(Icons.refresh),
            )
          ],
        ),
        body: FutureBuilder(
          future: getCurrentWeather(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            }

            final data = snapshot.data!;
            final currentTemp = data['list'][0]['main']['temp'];
            final currentSky = data['list'][0]['weather'][0]['main'];
            final currentPressure = data['list'][0]['main']['pressure'];
            final currentHumidity = data['list'][0]['main']['humidity'];
            final currentWindSpeed = data['list'][0]['wind']['speed'];

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(
                            sigmaX: 10,
                            sigmaY: 10,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Text(
                                  "$currentTemp K",
                                  style: const TextStyle(
                                    fontSize: 45,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Icon(
                                  currentSky.toString().toLowerCase() ==
                                              "clouds" ||
                                          currentSky.toString().toLowerCase() ==
                                              "rain"
                                      ? Icons.cloud
                                      : Icons.sunny,
                                  size: 64,
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  "$currentSky",
                                  style: const TextStyle(
                                    fontSize: 20,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "Weather forecast",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return HourlyForecaseItem(
                          icon: data['list'][index + 1]['weather'][0]['main']
                                          .toString()
                                          .toLowerCase() ==
                                      "clouds" ||
                                  data['list'][index + 1]['weather'][0]['main']
                                          .toString()
                                          .toLowerCase() ==
                                      "rain"
                              ? Icons.cloud
                              : Icons.sunny,
                          time: data['list'][index + 1]['dt_txt']
                              .toString()
                              .substring(10, 16),
                          temperature: data['list'][index + 1]['main']['temp']
                              .toString(),
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "Additional info",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      AdditionalInfo(
                        icon: Icons.water_drop,
                        label: "Humidity",
                        value: "$currentHumidity",
                      ),
                      AdditionalInfo(
                        icon: Icons.air,
                        label: "$currentWindSpeed",
                        value: "30",
                      ),
                      AdditionalInfo(
                        icon: Icons.beach_access,
                        label: "Pressure",
                        value: "$currentPressure",
                      ),
                    ],
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
