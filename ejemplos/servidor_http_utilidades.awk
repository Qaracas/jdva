BEGIN {
    for(n = 0; n < 256; n++)
        _ORD[sprintf("%c", n)] = n;
}

function es_ascii(ctr)
{
    if(!(ctr in _ORD) || _ORD[ctr] > 127)
        return 0;
    return 1;
}

function cnt_bytes(cadena,      c, i, j)
{
    i = j = 0;
    for (;;) {
        if ((c = substr(cadena[0], ++i, 1)) == "")
            return j;
        if (!es_ascii(c))
            j = j + 2;
        else
            j++;
    }
}