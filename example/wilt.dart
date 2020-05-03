/*
 * Package : WiltServerClient
 * Author : S. Hamblett <steve.hamblett@linux.com>
 * Date   : 03/09/2018
 * Copyright :  S.Hamblett
 */

import 'package:wilt/wilt.dart';
import 'package:json_object_lite/json_object_lite.dart' as jsonobject;
// ignore: avoid_relative_lib_imports
import '../test/wilt_test_config.dart';

// ignore_for_file: omit_local_variable_types
// ignore_for_file: unnecessary_final
// ignore_for_file: cascade_invocations
// ignore_for_file: avoid_print

/// A simple Wilt client example.
/// Please adjust the settings in wilt_test_config to suite your CouchDb setup.
/// If you are using the browser test please check your CORS settings
/// in CouchDB.
/// For more detailed examples of the API see the test suite.
///
// ignore: avoid_void_async
void main() async {
  /// Create a test client
  final Wilt wilting = Wilt(hostName, port: serverPort, useSSL: useSSL);

  /// Or for the browser
  /// final WiltBrowserClient wilting =
  //  new WiltBrowserClient(hostName, port, scheme);

  // Login if we are using authentication. If you are using authentication
  // try the example with this commented out, you should see all
  // the operations fail with 'not authorised'.
  if (userName != null) {
    wilting.login(userName, userPassword);
  }

  /// Create an example database
  dynamic res = await wilting.createDatabase('wilt_example');
  if (!res.error) {
    final dynamic successResponse = res.jsonCouchResponse;
    if (successResponse.ok) {
      print('EXAMPLE:: Example database created OK');
    } else {
      print('EXAMPLE:: Example database creation failed');
    }
  } else {
    print('EXAMPLE:: Example database creation failed');
  }

  /// Create a test document
  wilting.db = 'wilt_example';
  String returnedDocRev;
  const String putId = 'exampletestid';
  final dynamic document = jsonobject.JsonObjectLite<dynamic>();
  document.title = 'Created by a Put Request';
  document.version = 1;
  document.author = 'SJH';
  res = await wilting.putDocument(putId, document);
  if (!res.error) {
    final dynamic successResponse = res.jsonCouchResponse;
    if (successResponse.ok) {
      returnedDocRev = WiltUserUtils.getDocumentRev(successResponse);
      print(
          'EXAMPLE:: Example document created OK, revision is $returnedDocRev');
    } else {
      print('EXAMPLE:: Example document creation failed');
    }
  } else {
    print('EXAMPLE:: Example document creation failed');
  }

  /// Update the document to version 2, note we now supply the returned
  /// document revision from above.
  document.version = 2;
  res = await wilting.putDocument(putId, document, returnedDocRev);
  if (!res.error) {
    final dynamic successResponse = res.jsonCouchResponse;
    if (successResponse.ok) {
      returnedDocRev = WiltUserUtils.getDocumentRev(successResponse);
      print(
          'EXAMPLE:: Example document updated OK, revision is $returnedDocRev');
    } else {
      print('EXAMPLE:: Example document update failed');
    }
  } else {
    print('EXAMPLE:: Example document update failed');
  }

  /// Read it back
  res = await wilting.getDocument(putId);
  if (!res.error) {
    final dynamic successResponse = res.jsonCouchResponse;
    returnedDocRev = WiltUserUtils.getDocumentRev(successResponse);
    print('EXAMPLE:: Example document read OK, revision is $returnedDocRev');
    print('EXAMPLE:: Example document read OK, title is '
        '${successResponse.title}');
    print('EXAMPLE:: Example document read OK, version is '
        '${successResponse.version}');
    print('EXAMPLE:: Example document read OK, author is '
        '${successResponse.author}');
  } else {
    print('EXAMPLE:: Example document read failed');
  }
}
