    //   var request2 = http.MultipartRequest(
    //       'POST', Uri.parse('${SERVER_IP}/listings/delete-listing/26'));

    //   var sessionToken = await getSessionToken();
    //   var csrfToken = await getCSRFToken();

    //   Map<String, String> requestHeader = <String, String>{
    //     'Cookie': 'sessionid=${sessionToken};csrftoken=${csrfToken}',
    //     'X-Csrftoken': '${csrfToken}'
    //   };

    //   request2.headers.addAll(requestHeader);

    //   var response2 = await request2.send();
    //   var respStr2 = await response2.stream.bytesToString();
    //   print(respStr2);

    //   if (response.statusCode == 200) {
    //   } else {
    //     setState(() {});
    //   }