/*
 * BSD 3-Clause License

    Copyright (c) 2020, RAY OKAAH - MailTo: ray@flutterengineer.com, Twitter: Rayscode
    All rights reserved.

    Redistribution and use in source and binary forms, with or without
    modification, are permitted provided that the following conditions are met:

    1. Redistributions of source code must retain the above copyright notice, this
    list of conditions and the following disclaimer.

    2. Redistributions in binary form must reproduce the above copyright notice,
    this list of conditions and the following disclaimer in the documentation
    and/or other materials provided with the distribution.

    3. Neither the name of the copyright holder nor the names of its
    contributors may be used to endorse or promote products derived from
    this software without specific prior written permission.

    THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
    AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
    IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
    DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
    FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
    DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
    SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
    CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
    OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
    OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

 */

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LocalDatabaseService {
  final secureStorage = const FlutterSecureStorage();

  Future<void> updateSecurityToken(String? token) async {
    await secureStorage.write(key: 'token', value: token);
  }

  Future<void> deleteSecurityToken() async {
    await secureStorage.delete(key: 'token');
  }

  Future<String> getSecurityToken() async {
    String? token = await secureStorage.read(key: 'token');
    token ??= '0';
    return token;
  }

  Future<void> updateUserCookie(String? cookie) async {
    if (cookie == null || cookie.isEmpty) {
      return;
    }
    await secureStorage.write(key: 'woo_user_cookie', value: cookie);
  }

  Future<void> deleteUserCookie() async {
    await secureStorage.delete(key: 'woo_user_cookie');
  }

  Future<String> getUserCookie() async {
    final String? userCookie = await secureStorage.read(key: 'woo_user_cookie');
    if (userCookie == null || userCookie.isEmpty) {
      return '';
    }
    return userCookie;
  }
}
