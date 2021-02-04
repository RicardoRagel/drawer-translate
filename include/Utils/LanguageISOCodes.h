#ifndef LANGUAGEISOCODES_H
#define LANGUAGEISOCODES_H

#include <string>
#include <map>

using namespace std;

class LanguageISOCodes
{
public:

    // Return full list of language codes and names
    static map<string,string> getLanguageList();

    // Return the name for the input language code
    static string getLanguageName(string code);

    // Return the code for the input language name or "None" if it's not been found
    static string getLanguageCode(string name);

private:

    // Map of Language Codes to Language Names
    static map<string,string> _lang_map;
};

#endif
