(ARESONVC-ALG
(NAME "aresonvc")
(ARGUMENTS ("sound_type" "s1") ("sound_type" "hz") ("double" "bw")
           ("int" "normalization"))
(LINEAR s1)
(ALWAYS-SCALE hz)
(START (MAX s1 hz))
(TERMINATE (MIN s1 hz))
(LOGICAL-STOP (MIN s1))
(SAMPLE-RATE (MAX s1))
(STEP-FUNCTION hz)
(STATE ("double" "c3co" "exp(bw * -PI2 / s1->sr)")
       ("double" "c3p1" "susp->c3co + 1.0")
       ("double" "c3t4" "susp->c3co * 4.0")
       ("double" "omc3" "1.0 - susp->c3co")
       ("double" "c2" "0.0")
       ("double" "c1" "0.0")
       ("int" "normalization" "normalization")
       ("double" "y1" "0.0")
       ("double" "y2" "0.0;
    hz->scale = (sample_type) (hz->scale * (PI2 / s1->sr))"))
(DEPENDS ("c2" "hz" "c3t4 * cos(hz) / c3p1")
         ("c1" "hz" "(normalization == 0 ? 0.0 :
          (normalization == 1 ? 1.0 - omc3 * sqrt(1.0 - c2 * c2 / c3t4) :
              1.0 - sqrt(c3p1 * c3p1 - c2 * c2) * omc3 / c3p1))"))
(CONSTANT "c1" "c2" "c3co" "c3p1" "c3t4" "omc3" "normalization")
(FORCE-INTO-REGISTER c3t4 c3p1 normalization omc3)
(INNER-LOOP-LOCALS "            register double y0, current;")
(INNER-LOOP "current = s1;
            y0 = c1 * current + c2 * y1 - c3co * y2;
            output = (sample_type) y0;
            y2 = y1; y1 = y0 - current")
)
