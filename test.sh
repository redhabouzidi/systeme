#!/bin/sh

PROG="./convert_pgm"
TMP="/tmp/$$"

check_empty ()
{
    if [ -s $1 ]; then
        return 0;
    fi

    return 1
}

# teste si le pg a échoué
# - code de retour du pg doit être égal à 1
# - stdout doit être vide
# - stderr doit contenir un message d'erreur
check_echec()
{
    if [ $1 -ne 1 ]; then
        echo "échec => code de retour == $1 alors que 1 attendu"
        return 0
    fi

    if check_empty $TMP/stdout; then
        echo "échec => sortie standard non vide"
        return 0
    fi

    if ! check_empty $TMP/stderr; then
        echo "échec => sortie erreur vide"
        return 0
    fi

    return 1
}

# teste si le pg a détecté un format PGM invalide 
# - code de retour du pg doit être égal à 2
# - stdout doit être vide
# - stderr doit contenir un message d'erreur
check_invalid_format()
{
    if [ $1 -ne 2 ]; then
        echo "échec => code de retour == $1 alors que 2 attendu"
        return 0
    fi

    if check_empty $TMP/stdout; then
        echo "échec => sortie standard non vide"
        return 0
    fi

    if ! check_empty $TMP/stderr; then
        echo "échec => sortie erreur vide"
        return 0
    fi

    return 1
}


# teste si le pg a réussi
# - code de retour du pg doit être égal à 0
# - stdout et stderr doivent être vides
check_success()
{
    if [ $1 -ne 0 ]; then
        echo "échec => code de retour == $1 alors que 0 attendu"
        return 0
    fi

    if check_empty $TMP/stdout; then
       echo "échec => sortie standard non vide"
       return 0
    fi

    if check_empty $TMP/stderr; then
        echo "échec => sortie erreur non vide"
        return 0
    fi

    return 1
}

test_1()
{
    echo "Test 1 - tests sur les arguments du programme"

    echo  "--- Test 1.1 - sans argument.........................."
    $PROG                          > $TMP/stdout 2> $TMP/stderr
    if check_echec $?;                             then return 1; fi
    echo "OK"

    echo  "--- Test 1.2 - 1 argument............................."
    $PROG grumpy.pgm               > $TMP/stdout 2> $TMP/stderr
    if check_echec $?;                             then return 1; fi
    echo "OK"

    echo  "--- Test 1.3 - trop d'arguments......................."
    $PROG grumpy.pgm toto.pgm tata.pgm  > $TMP/stdout 2> $TMP/stderr
    if check_echec $?;                             then return 1; fi
    echo "OK"

    echo  "--- Test 1.4 - fichier d'entrée inexistant....................."
    $PROG ldjksqldfdsfsdf toto.pgm     > $TMP/stdout 2> $TMP/stderr
    if check_echec $?;                             then return 1; fi
    echo "OK"
}

test_2 ()
{
    echo "Test 2 - tests sur le format de fichier"

    echo "--- Test 2.1 - magic number invalide"
    $PROG grumpy1.pgm $TMP/out1.pgm
    if check_invalid_format $?;        then return 1; fi
    echo "OK"

    echo  "--- Test 2.2 - format invalide : valeur max > 255"
    $PROG grumpy2.pgm $TMP/out1.pgm
    if check_invalid_format $?;        then return 1; fi
    echo "OK"

    echo  "--- Test 2.3 - format invalide : il manque une valeur dans l'entête"
    $PROG grumpy3.pgm $TMP/out1.pgm
    if check_invalid_format $?;        then return 1; fi
    echo "OK"

    echo  "--- Test 2.4 - format invalide : le nombre de pixels n'est pas égal à dimx * dimy"
    $PROG grumpy4.pgm $TMP/out1.pgm
    if check_invalid_format $?;        then return 1; fi
    echo "OK"

    echo  "--- Test 2.5 - format valide (entête 'classique' avec caractères fin de ligne)"
    $PROG grumpy_ok1.pgm $TMP/out1.pgm
    if check_success $?;        then return 1; fi
    echo "OK"

    echo  "--- Test 2.6 - format valide (valeurs de l'entête séparées par des espaces)"
    $PROG grumpy_ok2.pgm $TMP/out1.pgm
    if check_success $?;        then return 1; fi
    echo "OK"
}

test_3 ()
{
    echo "Test 3 - tests sur les résultats (comparaison avec convert -compress none )"

    echo  "--- Test 3.1 - entête 'standard' "

    $PROG grumpy_ok1.pgm $TMP/out1.pgm
    convert grumpy_ok1.pgm -compress none $TMP/out2.pgm
    # normalisation des fichiers
    cat $TMP/out1.pgm | sed -E -e 's/\#.*$//' -e 's/[[:space:]]+/\n/g' | sed -e '/^$/d'  > $TMP/out1n.pgm
    cat $TMP/out2.pgm | sed -E -e 's/\#.*$//' -e 's/[[:space:]]+/\n/g' | sed -e '/^$/d'  > $TMP/out2n.pgm

    if ! cmp  $TMP/out1.pgm $TMP/out2.pgm;        then return 1; fi
    echo "OK"

    echo  "--- Test 3.2 - valeurs de l'entête séparées par des espaces "

    $PROG grumpy_ok2.pgm $TMP/out1.pgm
    convert grumpy_ok2.pgm -compress none $TMP/out2.pgm
    # normalisation des fichiers
    cat $TMP/out1.pgm | sed -E -e 's/\#.*$//' -e 's/[[:space:]]+/\n/g' | sed -e '/^$/d'  > $TMP/out1n.pgm
    cat $TMP/out2.pgm | sed -E -e 's/\#.*$//' -e 's/[[:space:]]+/\n/g' | sed -e '/^$/d'  > $TMP/out2n.pgm

    if ! cmp  $TMP/out1.pgm $TMP/out2.pgm;        then return 1; fi
    echo "OK"
}

test_4()
{
    echo  "Test 4 - test mémoire............................."
    valgrind --leak-check=full --error-exitcode=100 $PROG grumpy.pgm $TMP/toto.pgm > /dev/null 2> $TMP/stderr
    test $? = 100 && echo "échec => log de valgrind dans $TMP/stderr" && return 1
    echo "OK"

    return 0
}

# répertoire temp où sont stockés tous les fichiers et sorties du pg
mkdir $TMP

# Lance les 4 séries de tests
for T in $(seq 1 4)
do
	if test_$T; then
		echo "== Test $T : ok $T/4\n"
	else
		echo "== Test $T : échec"
	fi
done

rm -R $TMP
