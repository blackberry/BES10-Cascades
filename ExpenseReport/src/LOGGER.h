/* Copyright (c) 2013, 2014  BlackBerry Limited.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 */

#include <stdio.h>

/**
 * Simple log helper that logs to the Console Window of Momentics
 */
class LOGGER {
public:
    static void log(const char* msg) {
        fprintf(stdout, "%s\n", msg);
        fflush(stdout);
    }

    static void log(const char* msg, const char* value) {
        fprintf(stdout, "%s %s\n", msg, value);
        fflush(stdout);
    }

    static void log(const char* msg, int iValue, const char* value) {
        fprintf(stdout, "%s %d:%s\n", msg, iValue, value);
        fflush(stdout);
    }

    static void log(const char* msg, int value) {
        fprintf(stdout, "%s %d\n", msg, value);
        fflush(stdout);
    }

    static void log(const char* msg, int value, const char* value2, int value3) {
        fprintf(stdout, "%s %d %s%d\n", msg, value, value2, value3);
        fflush(stdout);
    }

    static void log(const char* msg, bool value) {
        fprintf(stdout, "%s %d\n", msg, value);
        fflush(stdout);
    }

    static void log(const QString& msg) {
        fprintf(stdout, "%s\n", msg.toLocal8Bit().data());
        fflush(stdout);
    }

    static void log(const QString& msg, const QString& msg2) {
        fprintf(stdout, "%s %s\n", msg.toLocal8Bit().data(), msg2.toLocal8Bit().data());
        fflush(stdout);
    }

    static void log_indent(const char* msg, int iIndentSpace) {
         fprintf(stdout, "%*s \n", 10+(iIndentSpace*7)+strlen(msg), msg);
         fflush(stdout);
     }

    static void log_indent(const char* msg, const char* value, int iIndentSpace) {
         fprintf(stdout, "%*s %s \n", 14+(iIndentSpace*7), msg, value);
         fflush(stdout);
     }

    static void log_indent(const char* msg, const QString& value, int iIndentSpace) {
         fprintf(stdout, "%*s %s \n", 14+(iIndentSpace*7), msg, value.toLocal8Bit().data());
         fflush(stdout);
     }

    static void log_indent(const char* msg, int value, int iIndentSpace) {
         fprintf(stdout, "%*s %d \n", 14+(iIndentSpace*7)/*+strlen(msg)*/, msg, value);
         fflush(stdout);
     }
};
