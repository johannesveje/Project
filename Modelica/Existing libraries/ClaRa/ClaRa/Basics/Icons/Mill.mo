within ClaRa.Basics.Icons;
model Mill "Icon for mill models"
//___________________________________________________________________________//
// Component of the ClaRa library, version: 1.0.0                        //
//                                                                           //
// Licensed by the DYNCAP research team under Modelica License 2.            //
// Copyright � 2013-2015, DYNCAP research team.                                   //
//___________________________________________________________________________//
// DYNCAP is a research project supported by the German Federal Ministry of  //
// Economics and Technology (FKZ 03ET2009).                                  //
// The DYNCAP research team consists of the following project partners:      //
// Institute of Energy Systems (Hamburg University of Technology),           //
// Institute of Thermo-Fluid Dynamics (Hamburg University of Technology),    //
// TLK-Thermo GmbH (Braunschweig, Germany),                                  //
// XRG Simulation GmbH (Hamburg, Germany).                                   //
//___________________________________________________________________________//

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                   graphics={Bitmap(
          extent={{-100,100},{100,-100}},
          imageSource=
              "iVBORw0KGgoAAAANSUhEUgAAAjAAAAIwCAYAAACY8VFvAAAABHNCSVQICAgIfAhkiAAAAAlwSFlzAAAN1wAADdcBQiibeAAAABl0RVh0U29mdHdhcmUAd3d3Lmlua3NjYXBlLm9yZ5vuPBoAACAASURBVHic7d15nGRlfe/xb/f0LCwzww4CDouyCIqKIigCAQWJuEtEDcEFF1yRAWZvpme6ZxgGRkWjcXuhMXqNEdfgTVADFxKu+kKDW6mkvHDoKejqrt737uqqun90FczSS1X1+T1n+7z/SmDm9zsO2L+vz3Oe5zQc99wz+iWtFAAAQDQMNEp6IuinAAAAqMETjZK8oJ8CAACgBh4rMAAAIGqeIMAAAICoIcAAAIDIIcAAAIDI4SVeAAAQOV5DqVTS8aecOSrpgKCfBgAAYB5jmXTqwMby/8M2EgAAiIInJIkAAwAAooQAAwAAImevAOMF9xwAAABV8yRWYAAAQLSwhQQAACKHAAMAACJnrwDzlKR8cM8CAAAwr7ymM8t0gMmkU0VJu4N8IgAAgHnsLmeWp1dgJLaRAABAuD2dVfYMMJ775wAAAKiaV/k/WIEBAABRMeMKDAEGAACE2dNZpWmPv+hZdbviNZfp9NNOsSofW8ViUd/70T16ot39+9UvP/ccveLclznvCwAVY2Pj+ua/fEcDA4NO+15w/sv1spec7bRnnPz50bR+fO9PrMp7lf9jzwBjtgJz4omr9MbXvdaqfCyVSiW17rg9kPDyxte9Vjd+/CPO+wLAvl5x3st03fWrNTw84qznf/3fX+iySy7WRRec76xnnIxPfN+y/IxbSBlJRYtunZ1dFmVj7bNf+LJ+dv8DzvtedMH5uuFjH3beFwBmsurZx6vtlo1qamqa/xf7pFQqqW3nHfrzo//jrGecGM78oqaziqQ9AkwmncpLetKiY7aLAFOLb/zzv+ju7//Qed8Xv/AFumXdzWpsaHDeGwBmc/aLXuh8VXhiYlLrNm9VZ1fOad84MJz5T5aziqS9V2Ako22kbLbTomws/fjen+hLd/2j877PPfkkbd9yixYvXuy8NwDM54rLL9M733al0569vX1a29yi0bExp32jznDm75VR3AQYVmCq8tAvfqnbP/VZ532fdczRumN7qw468EDnvQGgWh+89t268JWvcNrzscc9tbTtULFo8oZFLBnO/DkDjGfRcXh4RCOjoxalY+P3qT+qZZv7/5Icesgh+uSONh122KFO+wJArRoaGrRp7U06/VS3p1p/8fCvdOfnv+i0Z1SNjI5avnDt7fn/OFmBkdhGmsvjTzyhdc1bNDEx6bTvgQccoJ3btui4Y4912hcA6rVs6VLduvUWHXXkkU77fv9H9+juH/zIac8oMp717reQJLaRZtPZldNN65s1NDzstO/ipia1bd6k0055rtO+ALBQhx92mG5r3awDDzjAad+//8KX9fNfPuy0Z9QYz/pgAgxHqfc3ODikG9dvUq67x2nfxoYGbVx7o1569ouc9gUAvzzn5JPUsnGtGhv3HWN2isWiWrbfpr889riznlFjPOtZgQmD8YkJrW1uUfvuzPy/2Gcf+9AHdclFFzrvCwB+Ou9l5+hj133Aac+xsTGta96int5ep32jIrAVmEw6NS7JZAMrmyXAVBQKBd2ydbtSf/qz897XvPMqvfVNr3feFwAsvPVNr9db3uj2Z1pXLqd1zVs0PjHhtG8UGM76znJGedpMa28cpTZUKpV02yfv1C8e/pXz3q/769fofe++xnlfALD08Q99QOed81KnPR9N/0VtO25XsVRy2jfsXB2hlmYOMJ5FZ96BmfYPX7lL//7T/3De95WvOE83Xf9R530BwFpjY6NaNq3TySed6LTvgw/9XF/8yled9gw7w1nv7fsXnK3A9PX3Oz8mHDbfvvt7+ufvfM9537Oef6ZaNrh92Q0AXDrwgAN0W2uL8zutvvWd7+qef7vXac+wmpiYVF9/v1X5qlZg7E4iJXgb6d6f3afPf/ku531PPulE7di6WUuWLHHeGwBcOvqoI7Vjyy1autTtz7tdn/mcfv3Ib5z2DCPjGR/cFpIkZRO6jfTLh3+tHbs+rZLjvdJjjj5Kd2xv1cEHH+S0LwAE5fTTTtWmNTepweFHaQuFgppbt+uJ9t3OeoaR8Yz39v0LTldgsp3Ju433j39+VM2t21UoFJz2Xblyhe64tVVHHH6Y074AELSLLjhfH3jvu532HB4e0drmFvUPDDjtGybGMz7YLaSkrcC0785ozabNGh8fn/8X+2jZsmW6vW2LVh1/vNO+ABAWf3vVlbriNZc57flUR1YbNrcqn8877RsWxjN+/gCTSaeGJJnc0JOko9S57h7duH6TBgeHnPZtampS2y0bdfpppzrtCwBhc+P1H9GLX3iW055/+OOfdOsdn3LaMywMZ3xvOZvsZbZjKTZ3wSTkg45Dw8O6aUOzOrtyTvs2NDRo/U2f0MteerbTvgAQRk1NTWrbvNH5avTP7n9Ad339G057hoHhjJ8xkzgNMEk4hTQxMan1t2zV457ZTtysPvLB9+nSSy523hcAwmr5wQfrtrYWrVy5wmnfr33jW/rpffc77Rk0wxkffIDp6enV1NSURelQmP7Q1w797g8p573/9qor9ba3vMl5XwAIu+OOfZa2bd6kxYsXO+27Y9edgcyDIExNTamnx+z7UDUFGM/iCYqlkrpy3RalQ+H2T39WD/38l877/vVlr9YHr32P874AEBVnPf9MrV19vdOe+XxeG7e06cmnOpz2DUJXrtvyswreTH/R6QqMFN+j1F/+6tf143//ifO+rzj3ZVpzw8ed9wWAqLnsVRfr3Ve/w2nPgYFBrd3UoqHhYad9XXN9hFoKJMDE7z2Y7/7gX/VP3/q2877PP+N52rJpvRYtWuS8NwBE0XuvuVqvvvgipz3bMxlt2rIt1q9QuD5CLTneQpLi9yLvf/yfB/WZf/ii874nnrBKO1o3O78yGwCibv1NN+j5ZzzPac9Hfvs77brzc057umQ8272Z/uKMASaTTvVKMlnv6ojRUepf/fdvtH3nLuefCDjqyCO169ZWrVi+3GlfAIiDxYsXa/uWZj3rmKOd9v3xvT/RN799t9OerhjO9uFyJtnPXJ8n5ij1HB5N/0Ubt7Qp73hJcMXy5dp1a6uOPOIIp30BIE4OWblSO9u2OP9W3Jfu+poe+M+HnPZ0wfURamnuAOP5/xzxeAfmyaee0pqNmzU2Nua077KlS3VbW4tOWPVsp30BII5OWPVsbd20wel7hKVSSW0779CfH/0fZz1dMJzt3mx/w/kKTFeuW8Vi0aK0E729fVq9bpP6+vud9l20aJG2Nq/Xmc873WlfAIizl579Iq3+2Ied9pyYmNS6zVud39ZupVgsWl6RUtcKjEmAKRQK6u7psShtbmR0VDdtaHb+Hk9DQ4PWrr5e573sHKd9ASAJXv/ay/X2v3mL0569vX1a29yiUccr+Ra6e3pUKBSsyodnC0mK5jZSPp/Xhs1b9ZfHHnfe+7r3vUeXX/oq530BICmue997dcErXu6052OPe2pp2xHpXQnJfKZ7s/0N5yswUvQCTLFU0tYdt+uR3/7eee+rrnyL3vE3b3XeFwCSpLGhQc3rb9ZppzzXad9fPPwr3fl591dx+CmIO2AkAkxVPvXZzwfy1vhlr7pYH37/e533BYAkWrZ0qXa0bnZ+yvP7P7pHd//gR057+imMAaZT0rj/zxKto9Rf/adv6of3/G/nfc895yVad+Mn1NDQ4Lw3ACTV4YcdptvaWnTAAQc47fv3X/iyfv7Lh5329IvhTB/XdBaZ0awBJpNOlSS1WzxRVFZgfnjP/9ZX/+l/Oe97xumnqbV5g5qampz3BoCke+7JJ2nzhjVqdPg/IIvFolq23xbIe5YLZTjT28tZZEZzrcBIRttIUfig4wP/+ZA+9dnPO++76tnHa2fbFi1btsx5bwDAtFec+zJ99Lr3O+05Njamdc1b1NM748WzoWU40+fMIIEEmM6unPPr92vxyG9/r607brf8NPiMjjzicO26tU0rVvCJAAAI2pVvfqPe/PornPbsyuW0rnmLxicmnPatV6lUsrzPZkEBxvPvOZ4xOTmp/v4Bi9IL9pfHHteGzVuVz+ed9l1+8MG6Y3urjj7qSKd9AQCzu/4j1+ncc17itOej6b+oLYD/EV2P/v4BTU5OWpX35vqbgazASFJHCLeROrKdumlDs0ZGR532Xbp0iXa0btZJJ57gtC8AYG6NjY1q2bjO+c/nBx/6ub74la867VkP41kevi0kSeoM2Yu8ff39Wr1uk3p7+5z2rfyX4wVnnuG0LwCgOgcdeKBua23RoYce4rTvt77zXd3zb/c67Vkr41kevi0kScqG6Cj12NiY1mzcrCefesp575tv+JjOP+9c530BANU75uijtGPrZi1dusRp312f+Zx+/chvnPashfEs9+b6m/MFmKckTfn2KHvIOv6e0GzyU1PauKVNj6b/4rz3B977Ll3xmsuc9wUA1O55p52qjWtudHo/V6FQUHPrdj3RvttZz1oYzvIpTWeQWc0ZYDLpVEFSxs8nqgjDCkypVNK223bpV//tPt1e+aY36Oq3v815XwBA/f7qglfq/e+5xmnP4eERrW1uUf9A+A6/GM7yTDmDzGq+FRjJaBspDJfZfeYfvqj7HnjQed9XX3yRPvahDzjvCwBYuKvf/ja99jWXOu35VEdWGza3Oj8hOx/DWe7N9wuqCTA2d8EEHGD+6Vvf1nd/8K/O+7707Bdrw82r+UQAAETYTdd/VC9+4Quc9vzDH/+kW+/4lNOe8zGc5fNmj8ACzOjYmAaHhixKz+vH//4TffmrX3fe9/RTT9G2zRv5RAAARFxTU5PaNm/Ss48/zmnfn93/gO76+jec9pzN4NCQRsfGrMr7EmC8hT/HzIJYhXno57/U7Z/+rPO+xx93rHZu2+L8A2EAABvLDz5YO9tanN+e/rVvfEs/ve9+pz1nYjzDvfl+QWArMJL7F3l/94eUWrbvULFYdNr38MMO0yd3tOmQlSud9gUA2Dru2GO1vaVZix2vrO/Ydad+94eU0577Mp7h4d1CkqRs1l2Aedx7Qutu2aKJCbMrj2d00EEH6Y7tW3XM0Uc77QsAcOOs55+pNauvd9ozn89r45Y2PflUh9O+ezKe4b4EmN2STJYssl1u7oLp7Mrppg3NGh4ecdKvYsmSJdqx9RY95+STnPYFALj1mldfomve+XanPQcGBrV2U4uGhoed9q0wnOFFTWePOc0bYDLp1KQkk4jn4h2YwcEh3bh+k3LdPea99tTY2Khb1q/RC1/wfKd9AQDBuPZdV+uSiy502rM9k9GmLds0NWVy5+ycDGd4Rzl7zKmaFRjJaBupwzjAjI+Pa82mzWrfbXIX35xWf/wjuvD8lzvvCwAIRkNDgzbcfIPOPON0p30f+e3vtOvOzzntKZnO8KoyR6ABxnIFZmpqSs2t2/XHPz9q1mM2177rar3htZc77wsACNaSJUu0vaXZ+XuPP773J/rmt+922jPIO2Ck6gOMV/9zzG5waEhjBmfIS6WSduz6tH758K99rz2fN7/+Cr3rb9/hvC8AIBwOPeQQ7Wxr0UEHHeS075fu+poe+M+HnPQas73LzavmFwW6AiPZXEP8+S/fpZ/8h/sz8hdf+Epd/9EPOe8LAAiXE09Ypdbm9Vq0aJGznqVSSW0779CfH/0f817GnwMK/xaS5P8fwj9/53v69t3f87VmNc5+0Qu1ad3NauQTAQAATX865gbH/6N2YmJS6zZvVWdXzrRPlAKMV/9zzM3Pi3D+/af/oX/4yl2+1avWKc99jrZvcX+REQAg3N5wxV/rqre+2WnP3t4+rW1usbzm3/oSO6+aX1RtgGmv/znm5tdLQL94+Fe67ZN3qlQq+VKvWscd+yzdsW2rDuQTAQCAGXzoA9fqla84z2nPxx731NJmd/O88TUoVWWOqgJMJp0alWSyHtXRufCLcFJ/+rNu2bpdhULBhyeq3qGHHqI7trfq0EMPcdoXABAdjQ0NumXdzTr1uc9x2vcXD/9Kd37+iya1/Zjds8iVM8e8ql2BkYy2kRaa4tp3Z7S2uUXjExM+PVF1DjrwQN2xbauOO/ZZTvsCAKJn2bJl2tHaoiOPONxp3+//6B7d/YMf+V7XcAXGq/YX1hJgTF7kXcg+Wq67Rzeu36TBQbOjXDNavHixtm9p1imO0zQAILqOOPww7Wht0bJly5z2/fsvfFk//+XDvtY0fAem6qwReIDp6+vX5GTtH1gcGh7WTeubzd+03ldjQ4Oa192kF7/wLKd9AQDRd8pzTtbmDWucnlgtFotq2X6b/vLY477Um5ycVF9fvy+1ZhCdAFMqlWoOIRMTk1rXvEWPP2F2untW13/0Q/qrC17pvC8AIB7OP+9cffiD73Pac2xsTOuat6int3fBtTq7cpYHZkwCjFf7c1Sns4alqGKxqJZtO/T71B+tHmdW7776HXrz669w3hcAEC9ve8ub9MbXvdZpz65cTuuatyz4ndFaZnYdvGp/YeArMJLUka3+bebbP/VZPfSLX1o9yqze8NrL9d5rrnbeFwAQT5/4yHU65yVnO+35aPovattxu4oLWEGpZWbXITpbSFL1ae5Ld/2jfnzvT6weY1YXnv9yrb7+o877AgDia9GiRdravF4nnXCC074PPvRzffErX6379xuvwPgfYDLp1IAkk7d2qrmS+O7v/1Df+Od/sWg/pxed9QJt3rCWTwQAAHx30IEH6ra2Fh16iNv7xL71ne/qnn+7t67fa/gZgf5y1qhKLSswktVR6nn+MH52/wP67Be+bNF6Ts85+STduqVZixcvdt4bAJAMxxx9lG7deouWLFnitO+uz3xOv37kNzX/PsMAU1PGCH2A+dV/P6Ltt3/S+ScCnnXM0bpj+1bnn0MHACTPGaefpo03r1aDw9X+QqGg5tbteqJ9d02/L6oBxqvx11elu6dnxs8A/Pl/0tq4ZZumpqYs2s7qkJUrtevWNh1+2GFO+wIAkuviiy7Qte/6O6c9h4dHtLa5Rf0D1e3cFAoFdff0WD2OV8svDsUKTLFYVK67e6+/lnnyKa3ZuFljhl/TnMkBBxygndu26PjjjnXaFwCAa955lS6/9FVOez7VkdWGza3K5/Pz/tpcd7fZByIVxS0kSerIPrMk1dPbqxvXb6o6EfplcVOTtm3eqNNPPcVpXwAAKm6+4eN60VkvcNrzD3/8k26941Pz/ro9Z7WB6G0hSc8cyxoZGdFNG26xPme+n4aGBm1Yc6NeevaLnfYFAGBPi5ua1LZ5o/OdgJ/d/4Du+vo35vw1YbnETgrRCky2s0v5fF7rN7fq//n0vYZafOxDH9Cr/upC530BANjXiuXLtbNti1YsX+6079e+8S399L77Z/37hi/wSpYrMJl0qlvSSE2PU6WObFZbbt2p3/zu9xbl5/R377hKV77pDc77AgAwm+OPO1ZtmzdqcVOT0747dt2p3/0hNePfy3aa7Y6MlDNG1WpdgZGMVmEe/vUjevC//q9F6Tldcfllev97rnHeFwCA+bzorBfo5hs+7rRnPp/Xxi1tevKpjv3+XliOUEshCjCGx7Jmdf7Lz9XNn/iY874AAFTr8ktfpWveeZXTngMDg1q7qUVDw8N7/XXDd2CiG2BcO+v5Z6plwzo1NtbzRwAAgDvXvuvvdPFFFzjt2Z7JaNMed7EVSyV1deWs2hFgqnHSiSdox9bNWrrU7bXNAADUo6GhQRtvXq0zTj/Nad9Hfvs77brzc5Kknp5e5e0ulnUSYLw6fk9oHH3Ukbpje6sOPphPBAAAomPJkiW6destOuboo5z2/fG9P9E3v313qI5QSwlbgVmxYrl27WjTkUccHvSjAABQs0MPOUS3tbXooAMPdNr3S3d9Tfc/+F+WLdhCms2yZct0+7atWnX88UE/CgAAdTvphBO0tXm9Fi1a5KxnqVTS93/4r5YtnASYDkmTdfy+wDQ1Nam1eYOed9qpQT8KAAALds5LztYnPnKd055TM3x02SeTms4WNak5wGTSqZKk9lp/X1AaGhq07sZP6NxzXhL0owAA4Js3vu61ettb3hT0Y/ihvZwtalLvGeLIbCN9+APX6rJXXRz0YwAA4LsPf/B9Ov+8c4N+jIWqK1PUG2C8On+fU+/4m7fqqre+OejHAADARGNDgzZvWKNTnnNy0I+yEF49vym2KzCXX/oqXfe+9wT9GAAAmFq2bJl2tLboiMMPC/pR6uV0BSbUAebl556jtauvV0NDQ9CPAgCAuSOPOFw7Wlu0bNmyoB+lHmwhSdKZZ5yuLZvcHi8DACBopz73Obpl3c1qjN7/ePfq+U2xWoE5YdWzdVtri5YtXRr0owAA4NwrX3GePvSBa4N+jFo5XYF5UpLZgfB6HHnEEdp1a6tWLF8e9KMAABCYq976Zr3hir8O+jGqVdB0pqhZXQEmk05N1dvQworly7Xr1lYddeSRQT8KAACBu+GjH9JLz35x0I9RjSfLmaJm9a7ASCF5D2bZ0qW6rbVFJ56wKuhHAQAgFBYtWqTW5vVRmI1evb9xIQEm8PdgFi1apC2b1uvMM04P+lEAAAiVgw46SDvbWnToIYcE/ShzqTtLRDrArF19vV5+7jlBPwYAAKF0zNFHa3tLs5YsWRL0o8wmkADjLeD3Lth173uPLr/0VUE+AgAAoXfmGadrw803hPVuNK/e3xjJFZi3veVNeufbrgyqPQAAkXLJRRfq2nddHfRjzCQ5W0iXXnKxPvLB9wXRGgCAyLrmnW/Xa159SdCPsa9AAky7pJo/f70QL3vp2Vp/0yfCugwGAECorVl9vc56/plBP0ZFSdNZoi51B5hMOjUhKVvv76/V8047VW23bFRTU5OrlgAAxMripiZtb2nWccceG/SjSFK2nCXqspAVGMnRNtKq44/XzrYtUf1IFQAAobFixXLtbGvR8oMPDvpRFpQhFhpgvAX+/nkdcfhhuuPWVq1cucK6FQAAifDs449T2+ZNQe9qeAv5zaFegTn44IO069Y2HXP0UZZtAABInBe/8AW66fqPBvkIga7AmAWYxYsXa8fWzTrpxBOsWgAAkGivfc2luvrtbwuqfTwDzDuvujJMb0oDABBL73/PNfqrC14ZROt4vgNzxGGHWZUGAABlDQ0N2rjmRj3vtFNdt/YW8ptDuwKT7eqyKg0AAPawdOkS7di62fU7p8GtwGTSqRFJPQupMZtsttOiLAAAmMGhhx6i21pbdNCBB7po11POEHVb6AqMZLSNxAoMAABunXTiCWrZuE6NjX7Egzl5Cy3gxxOabCN1dhJgAABw7dxzXqLrP3KddZsFZ4fQBpie3j7lp6YsSgMAgDm8+fVX6C1vfL1li1AEGM+HGvsplUrqYhsJAIBAXPkm0wDjLbRAaFdgJCnLNhIAAIHo7MpZlg/FCgwBBgCAmDGewaEIMJ4PNWZEgAEAIBjGM9hbaIEFB5hMOtUvaXChdWbSyTswAAAEwnAGD5azw4L4ddDbZBuJFRgAAIJhOIN9yQx+BRjPpzp7yXZyGy8AAEEwnMGeH0VCvQKT6+5RsVi0KA0AAGZRLBaV6zb5UpAUshUYkwBTKBQs/wABAMAMct09KhQKVuXjH2AktpEAAHDNePaGKsB4PtXZDy/yAgDgVtiPUEsRWIHhKDUAAG4Zz97wrMBk0qkuSWN+1NpXR5YtJAAAXDKcvWPlzLBgfq3ASEarMKzAAADgluHs9S0rhD7A8A4MAABuhf0SOykCAaazK6dSqWRRGgAA7KNUKll+iTqUAcbzsdbT8vm8evv6LEoDAIB99Pb1KZ/PW5X3/CoU+hUYiW0kAABcMZ65oVyB4Sg1AAARF4Uj1FIEtpAkqSNLgAEAwAXjmev5VcjPANMhyWTTjBUYAADcMJy5eU1nBV/4FmAy6VRR0m6/6u2Jd2AAAHDDcObuLmcFX/i5AiOZ3QXDbbwAALhgOHN9zQh+BxjP53qSWIEBAMAVw5nr+VksEisw4+PjGhwcsigNAADKBgeHND4+blU+1CswZkepO9hGAgDAlPGsDXWA8Xyu97ROtpEAADBlPGs9P4tFZgUmy1FqAABMGc/aUK/AZCT5dkRqT7zICwCALcNZW9R0RvCNrwEmk07lJT3pZ80KjlIDAGDLcNY+Wc4IvvF7BUYy2kbiHRgAAGwZzlrfs0FkAgxbSAAA2DKctZEIMJ5BTQ0ND2tkdNSiNAAAiTcyOqqh4WGr8p7fBSOzAiOxjQQAgBXjGRuJFRiOUgMAEDFROkItRWgLSZKyWU4iAQBgwXjGen4XtAgw7ZJKBnVZgUHdHnvc030PPBj0YwCm7nvgQT32uBf0YyCiDGdsSdPZwFdNfhfMpFPjx59yZpeko/2uzTswqMdjj3v6xJoNGhwaUqFQ0KWXXBz0IwG+++l992vbzk9qxfLl+vTO7Tr5pBODfiREjOGM7cqkU75/IdJiBUYyeg+mgwCDGlXCS//AgIrForbt/KR+et/9QT8W4KtKeCkWi+ofGNAn1mxgJQY1M5yxJpnAKsB4FkVZgUEt9gwvFYQYxM2e4aWCEIN6GM5Yz6JopFZg+vr7NTExaVEaMTNTeKkgxCAuZgovFYQY1GJiYlJ9/f1W5SO1AmN3F0yOVRjMba7wUkGIQdTNFV4qCDGolvFsjVSA8YzqKpslwGB21YSXCkIMoqqa8FJBiEE1jGerZ1E0ciswHKXGbGoJLxWEGERNLeGlghCD+UTtEjspggGGF3kxk3rCSwUhBlFRT3ipIMRgLlH7jIBkFGAy6dSQpF6L2h2d3MaLvS0kvFQQYhB2CwkvFYQYzMZwtvaWM4HvrFZgJKPExQoM9uRHeKkgxCCs/AgvFYQYzMRwtprtyEQuwGQJMCjzM7xUEGIQNn6GlwpCDPZlOFsjGWA8i6I9PT2ampqyKI0IsQgvFYQYhIVFeKkgxKBiampKPT09VuU9q8KRW4EplkrqynVblEZEWIaXCkIMgmYZXioIMZCkrly3iiWTbzBLEV2BsTuJxFHqxHIRXioIrijFMAAAIABJREFUMQiKi/BSQYiB8UwlwOyJ92CSyWV4qSDEwDWX4aWCEJNsxjM1kgHGsyqc5Sh1Innt7RocMjmNNydCDFwJIrxUDA4NyWtvd94XwTOeqZ5VYbMAk0mneiUNW9RmBSaZLrnoQm1cs1qNjZa5e2aEGFgLMrw0NjZq45rVuuSiC533RvAMZ+pwOQuYsJ4EHKWGry695GJCDGInDOHl0ksudt4b4RDFI9SSfYDxLIqyhZRshBjECeEFQTOcqZ5VYSmiKzC57h7LI1+IAEIM4oDwgqAVSyXlus3ugIn0CozJwxtfuoOIIMQgyggvCAPjy2EjHWA8q8IdWbaRQIhBNBFeEBbGs9SzLB7JFRiJy+zwDEIMooTwgjCJ6iV2UoQDDCeRsCdCDKKA8IKwieoldpJ9gOmUNG5RmACDfRFiEGaEF4SR4Swd13QGMGP6kz6TTpUkmVztSIDBTAgxCCPCC8LKcJa2lzOAGRc/5U2WkDoJMJgFIQZhQnhBmBnOUtPtIynCASbLS7yYAyEGYUB4QdgZztJYBBjPoujk5KT6+votSiMmCDEIEuEFYdfX16/JyUmr8p5V4YrIrsBIrMJgfoQYBIHwgigwnqGxWIHhKDUCRYiBS4QXREWUj1BLEd5CkvioI6pHiIELhBdEifEM9SyLS24CzFOSTD60wAoMakGIgSXCC6LGcIZOaXr2mzL/SZ5JpwqSMha1OUqNWhFiYIHwgigynKGZ8uw35eqnuGdRtIMtJNSBEAM/EV4QVYYz1LMqvCdXP8G5zA6hQoiBHwgviLIoX2InRTzAjI6NaWh42KI0EoAQg4UgvCDKhoaHNTo2ZlU+VgHGsyrMi7xYCEIM6kF4QdQZz07PsnhFpFdgJI5SY+EIMagF4QVxYDw7Y7UCY/Yfhvdg4AdCDKpBeEFcGM/OWAWY3ZJM/hvPFhL8QojBXAgviBPD2VnU9Mw35+QndSadmpTUYVGbLST4iRCDmRBeEDeGs7OjPPPNufwpbbKkxAoM/EaIwZ4IL4gjw9npZPtIikOA4YvUMECIgUR4QXwZzs5YBhjPoujg4JDG7M6yI8EIMclGeEFcjY2NaXBwyKq8Z1V4X5FfgZFYhYEdQkwyEV4QZ8YzM5YrMBylRiQRYpKF8IK4i8MRaikGW0iS1EGAgTFCTDIQXpAExjPTsyy+J5c/jdutCrMCAxcIMfFGeEFSGM9Ms1m/L2c/iTPp1KiknEVtjlLDFUJMPBFekCSGMzNXnvVOuP4p7FkU7eQlXjhEiIkXwguSxnBmelaFZ+L6J7DJyz0d3MYLxwgx8UB4QRIZzkxnL/BKMQkwfX39yufzFqWBWRFioo3wgiTK5/Pq6+u3Kh/rAONZFC2VSursMnm9BpgTISaaCC9Iqs6unEqlklV5z6rwTGKxAiPxUUcEhxATLYQXJJnxrIz1CoxhgOFFXgSHEBMNhBcknfGsJMDUgwCDoBFiwo3wAhBg6pZJpwYkmbw9xBYSwoAQE06EF2Ca4azsL894Z9z/lDVKaKzAICwIMeFCeAGeYTgrna6+SDEKMFxmhzAhxIQD4QXYm+GsTESA8SyK5rp7VCgULEoDdSHEBIvwAuytUCgo191jVd6zKjyb2KzAFItF5bq7LUoDdSPEBIPwAuwv191t+d+JRKzAcBIJiUKIcYvwAswsTieQpBhtIUkEGIQXIcYNwgswO+MZ6VkWnwkrMIAjhBhbhBdgbqzALFAmneqWNGJRu5MAg5AjxNggvADzM5yRI+XZ7lQQKzCS1V0wHKVGBBBi/EV4AapjOCOdr75IcQsw3MaLiCDE+IPwAlTPcEYSYBaqy/Yz4YCvCDELQ3gBqlcqldTVlbMqn6gA41kUzU9Nqae3z6I0YIIQUx/CC1Cbnt4+5aemrMp7VoXnEqsVGIltJEQPIaY2hBegdsazMVErMBylBvZAiKkO4QWoT9yOUEsxDDAcpUZUEWLmRngB6mc8GxMVYDokTVoU5ig1oowQMzPCC7AwhrNxUtMz3blAAkwmnSpJareozTswiDpCzN4IL8DCGc7G9vJMdy6oFRjJ7C4YVmAQfYSYaYQXwB+GszGQ7SMp2ADjWRTlHRjERdJDDOEF8I/hbPSsCs8ndisw4xMT6h8YsCgNOJfUEEN4AfzTPzCg8YkJq/KJXIHhKDVQhaSFGMIL4K84HqGWYriFJLGNhPhJSoghvAD+M56JnmXxucR0BYaTSIifuIcYwgtgI4638ErBBpgnJRUsCnMXDOIqriGG8ALYMZyJBU3P8kAEFmAy6dSUpIxFbd6BQZzFLcQQXgBbhjMxU57lgQhyBUbiLhigLnEJMYQXwF4c74CRCDBAZEU9xBBeADcIMDZM/sOPjIxoZGTEojQQKlENMYQXwA3jeZjoAONZFWYVBkkRtRBDeAHcMZ6FnmXx+QQdYLjMDvBBVEIM4QVwK66X2EkEGCA2wh5iCC+AewQYO+2STD7DzV0wSKKwhhjCCxAMw1lY0vQMD0ygASaTTk1IylrU5jZeJFXYQgzhBQiO4SzMlmd4YJqCbF72hKRn+V2U7yEhySoDO4jgUAkxFYQXIDiGszDQ7SMpHAHGk3Se30V5BwZJF3SIabttlySpVDLZJZ4T4QWYZjgLPavC1Qr6HRjJKMX1DwxofCLQ1S0gcEFuJ5VKJcILEKDxiQn1DwxYlQ98BSa2AUZiGwmQgg0xrhFegGcYz0ACjLjMDjCXhBBDeAH2FudL7KRwBBi7FRiOUgNPi3OIIbwA+zOegazAyPAPoYOj1MBe4hhiCC/AzIxnIAEmk06NSOqxqM07MMD+4hRiCC/A7AxnYHd5dgcqLD/BPIuivAMDzCwOIYbwAszNcAYGvvoihSfAmPxhcBsvMLsohxjCCzA/wxlIgNmDyR9GT2+f8lNTFqWBWIhiiCG8APPLT02pp7fPqjwBZg+eRdFSqaSurpxFaSA2ohRiCC9Adbq6cpYXSXpWhWsRlp9YZmmObSRgflEIMYQXoHrGs48VmD3YBRjuggGqEuYQQ3gBamM8+wgwe/CsCnOUGqheGEMM4QWonfHs8yyLVysUP6Uy6VS/pEGL2hylBmoTphBDeAHqYzj7BsszO3DB/4R6htFRagIMUKtKiGloaAjsGRoaGggvQJ3ifgeMFK4A41kUJcAAAJLGcPZ5VoVrFaYAY5Lqct3dKhaLFqWB2Prpffdr285PWh7DnFepVNK2nZ/UT++7P7BnAKKoWCwq191tVZ4VmBmY/KEUCgXluk0+tQTEUiW8hCH4F4tFQgxQo1x3jwqFglV5AswMPKvCxp8UB2IjTOGlghAD1MZ45nmWxWsRpgBjeJkdAQaYTxjDSwUhBqie8cxjBWYG3MYLBCTM4aWCEANUJwm38EohCjCZdKpL0phFbVZggNlFIbxUEGKA+RnOvLHyrA6F0ASYMu6CARyKUnipIMQAc0vCHTBSYgIMW0jAvqIYXioIMcDsDGceAWYOJn84nbafFQciJ8rhpYIQA+yvVCqpsytnVZ4AMwfPomg+n1dfXyg+3QAELg7hpYIQA+ytr69f+XzeqrxnVbgeYQswZumug20kIFbhpYIQAzzDeNaxAjMHsz8cLrND0sUxvFQQYoBpxrOOADMHz6owJ5GQZHEOLxWEGMB81nmWxWsVtgDTIclk866TAIOESkJ4qSDEIOkMZ11e0zM6NEIVYDLpVFHSbovaHQQYJFCQ4aWhoUENDQ3O+xJikGSGs253eUaHRqgCTJlnUZQVGCRNkOGlsbFRm9beqE1rb1Rjo/sfM4QYJJXhrPOsCterKegHmIHNZXa8xIsECTq8bFyzWpdecvHTfy2IZ6mEGEl7PQsQZ4azLlQv8ErhXIEx+UMaGxvT4OCQRWkgVMIWXi695GJtXLOalRjA2ODgkMbGTD4pKBFgqmL3VWpWYRBzYQsvFYQYwJ7xjCPAVMGzKsxRasRZWMNLBSEGsJWkI9RSOAOM3QoMt/EipsIeXioIMYAd4xnHCkwVMpJMfgqzAoM4ikp4qSDEADYMZ1xR07M5VEIXYDLpVF7Skxa1OUqNuIlaeKkgxAD+M5xxT5Znc6iELsCUcZQamEdUw0sFIQbwV5KOUEtJCzBZ3oFBPEQ9vFQQYgD/GM44AkwNPIuiQ8PDGrU7Iw84EZfwUkGIARZudGxMQ8PDVuU9q8ILEdYAY5b2eA8GURa38FJBiAEWxni2sQJTA7M/rA6OUiOi4hpeKggxQP2MZxsBpgaeVWFWYBBFcQ8vFYQYoD7Gs82zLF6vsAaYdkkli8LcBYOoSUp4qSDEALUznG0lTc/k0AllgMmkU+OSTP5pcBsvoiRp4aWCEAPUxnC2dZVncuiEMsCUeRZFWYFBVCQ1vFQQYoDqGc42z6rwQoU5wHCZHRIr6eGlghADVCdpl9hJCQwwfX39mpyctCgN+ILwsjdCDDC3yclJ9fX1W5UnwNTB7qvUrMIgpAgvMyPEALMznmkEmDp4VoU5So0wIrzMjRADzCyJR6ilcAcYuxUYAgxChvBSHUIMsD/jmcYKTB0IMEgEwkttCDHA3ggwIZNJp4Yk9VrUJsAgLAgv9SHEAM8wnGm95VkcSqENMGUmya+Tl3gRAoSXhSHEANMMZ1poV1+khAaYjiy38SJYhBd/EGIA05lGgFkAz6JoT0+PpqamLEoD8yK8+IsQgySbmppST0+PVXnPqrAfwh5gTNJfsVRSrtvsHzgwK8KLDUIMkirX3aNiyeTbxxIrMAtieBKJbSS4RXixRYhBEhnPMgLMAnhWhTmJBJcIL24QYpA0xrPMsyy+UGEPMNwFg8gjvLhFiEGSJPUOGCnkASaTTvVKGraozVFquEB4CQYhBklhOMuGyzM4tEIdYMo4So1IIrwEixCDJEjqEWopGgHGsyjKCgwsEV7CgRCDuDOcZZ5VYb9EIcCYpMCuXLfl0TMkGOElXAgxiKtiqaSuXLdVeVZgfGDyh2h8+Q8SivASToQYxJHxpawEGB94VoU5iQQ/EV7CjRCDuEnyEWopGgHGLAV2EmDgE8JLNBBiECfGM4wVGB+Y/SF2cBsvfEB4iRZCDOLCeIYRYHzQKWncpDArMFggwks0EWIQB4YzbFzTszfUQh9gMulUSVK7Re0sR6mxAISXaCPEIOoMZ1h7efaGWugDTJnJUlY2S4BBfQgv8UCIQZQZzrDQbx9J0QkwnkXRzhwBBrUjvMQLIQZRZTjDPKvCfopKgDFJgxMTk+rr77cojZgivMQTIQZR09ffr4mJSavyrMD4iKPUCBzhJd4IMYiSpB+hlggw6iDAoAqEl2QgxCAqjGeXZ1ncL1EJMJ5VYVZgMB/CS7IQYhAFrMBEJ8A8Jcnkgw8cpcZcCC/JRIhB2BnOrilNz9zQi0SAyaRTBUkZi9rZbOjv6kFACC/JRohBmBnOrkx55oZeJAJMmWdRlBUYzITwAokQg/AynF2eVWG/RSnAmOzJ8Q4M9kV4wZ4IMQgjw9kVifdfJAKMRkZHNTQ8bFEaEUR4wUwIMQiToeFhjYyOWpUnwBjwrApnWYWBCC+YGyEGYWE8szzL4n6KUoDhMjuYIbygGoQYhAFHqKcRYCRlOzmJlGSEF9SCEIOgGc8sAoyB3ZJMJgxbSMlFeEE9CDEIkuHMKmp61kZCZAJMJp2alNRhUZuj1MlEeMFCEGIQFMOZ1VGetZEQmQBTxlFq+ILwAj8QYhAEjlBPi1qA8SyKdvAOTKIQXuAnQgxcM5xZnlVhC1ELMCbpcHBwSOPj4xalETKEF1ggxMCV8fFxDQ4OWZVnBcaQ4UkktpHijvACS4QYuGA8qwgwhjhKjboQXuACIQbWOEL9jKgFGM+qMCsw8UV4gUuEGFjiFt5nRC3AtFsV7uQodSwRXhAEQgysGM8qsxlrIVIBJpNOjUrKWdTuyBJg4obwgiARYmDBcFblyjM2MiIVYMo8i6KswMQL4QVhQIiB3wxnlWdV2EoUA4zJS0a8AxMfhBeECSEGfjKcVZF6gVciwDytt69P+XzeojQcIrwgjAgx8EM+n1dvX59VeQKMA55F0VKppM4uk9dr4AjhBWFGiMFCdXblVCqVrMp7VoWtRDHAcJkd9kN4QRQQYrAQXGK3NwLMHniRN5oIL4gSQgzqZTyjCDAOeFaFO7Lcxhs1hBdEESEG9TCeUZ5lcQuRCzCZdGpQUr9FbVZgooXwgigjxKBWhjOqvzxbIyVyAaaMo9QJR3hBHBBiUAuOUO+NALMHPugYDYQXxAkhBtUynFEEGIc8i6K57h4VCgWL0vAJ4QVxRIjBfAqFgnLdPVblPavClqIaYEzSYrFYtPwXBAt03wMPEl4QW2EIMfc98KDz3qhOrrvH8mcfKzAOGd4FwzZSWJ24apVWLF/uvC/hBa4EGWJWLF+uE1etct4X1TGeTQQYhzyrwrzIG14nn3SiPr1zuw5ZudJZT8ILXAsixByycqU+vXO7Tj7pRGc9URvj2eRZFrcS1QDDZXYJ5TLEEF4QFJchhvASDVxit79IBphMOtUtacSiNisw4ecixBBeEDQXIYbwEh2Gs2mkPFMjJ5IBpoy7YBLMMsQQXhAWliGG8BIt3AGzPwLMPggw0WERYggvCBuLEEN4iR4CzP4IMPvo6uqy/Fw5fOZniCG8IKz8DDGEl+gplUrqsnsHhgATAM+iaH5qSj29fRalYcSPEEN4Qdj5EWIIL9HU09un/NSUVXnPqrC1KAcYu5NIbCNFzkJCDOEFUbGQEEN4iS7jmcQKTADsLrPjKHUk1RNiCC+ImnpCDOEl2oxnEgEmAJ5V4WyW23ijqpYQQ3hBVNUSYggv0Wc8kzzL4paiHGCykiZMCrMCE2nVhBjCC6KumhBDeIkHw5k0oelZGkmRDTCZdKokabdFbd6Bib65QgzhBXExV4ghvMSH4UzaXZ6lkRTZAFNmcxcMKzCxMFOIIbwgbmYKMYSXeDGcSZF9/0WKfoDxLIpymV187BliCC+Iqz1DDOElfgxnkmdV2IWmoB9ggUzS4/j4uAYGBrVy5QqL8nCsEmK89nZdctGFQT8OYOLSSy7WokWLdOKqVYSXGBkYGNT4+LhV+UivwBBgZpHt6iLAxMjJJ53ID3XEHgE9fjhCPTu2kGbBUWoAQNA4Qj27qAcYLrMDAMQWKzCzi3qAeVJSwaIwR6kBAEEznEUFTc/QyIp0gMmkU1OSMha1OzrZQgIABMtwFmXKMzSyIh1gykyWwFiBAQAEzXAWRXr7SCLAzIp3YAAAQeMSu9nFIcB4FkWHh0c0MjJiURoAgHmNjIxoeNhsDnlWhV2JQ4CxO4nENhIAICDGM4gVmBDgKDUAIHY4Qj03AswceJEXABAU4xlEgAmBdkkmnwPvIMAAAAJiOINKmp6dkRb5AJNJpyYkZS1qswIDAAiK4QzKlmdnpEU+wJRxlBoAECscoZ5bXAKMZ1GUDzoCAIJiOIM8q8IuxSXAmKTJ/oEBjU9EfpUNABAx4xMT6h8YsCrPCkyImP3D6OrKWZUGAGBGxrOHABMinlXhDraRAACOGc8ez7K4K3EJMHZ3wfAiLwDAMePZwwpMiPA5AQBAbPAZgfnFIsBk0qkRSd0WtbOdbCEBANwynD3d5ZkZebEIMGU2d8GwAgMAcMxw9sRi9UUiwMyLd2AAAK4Zzh4CTAiZ/EPp6elVfmrKojQAAPvJT02pp6fXqrxnVdi1OAUYz6JosVTiLhgAgDNdXTkVSybfKJZYgQkljlIDACKPI9TVIcBUgRd5AQCucIS6OnEKMJ5VYY5SAwBcMZ45nmVxl2ITYDLpVL+kQYvarMAAAFwxnDmD5VkZC7EJMGUcpQYARBpHqKsTtwDjWRTtyBJgAABuGM4cz6pwEOIWYEzSZa67W8Vi0aI0AABPKxaLynWbfBlHYgUm1Ez+4RQKBXX39FiUBgDgad09PSoUClblCTAh5lkV5kVeAIA141njWRZ3LW4BhrtgAACRxR0w1SPAVIkAAwCwRoCpXqwCTCad6pI0ZlGbo9QAAGuGs2asPCNjI1YBpswkYXZkuY0XAGDLcNbEavVFIsBUjRUYAIA1LrGrHgGmSp1dOZXsPm8OAEi4Uqmkzq6cVXkCTAR4FkUnJyfV1xebT0gAAEKmr69fk5OTVuU9q8JBiWOAsTuJxDYSAMCI8YxhBSYCzP4hdXKUGgBgxHjGEGAiwLMq3NHJSSQAgA3jGeNZFg9CHANMh6S8RWFWYAAAVgxnTF7TszFWYhdgMulUUdJui9q8AwMAsGI4Y3aXZ2OsxC7AlHkWRfmcAADAiuGM8awKBymuAcbkZSUCDADAiuGMid0LvBIBpiZjY2MaHBqyKA0ASLDBoSGNjZl8yk8iwESKZ1WYF3kBAH4zni2eZfGgxDXAmKXNDgIMAMBnxrOFFZgI4TI7AEBkcIld7eIaYHZLMjkylu3iMjsAgL8MZ4vZ1SJBi2WAyaRTU5KetKidzbICAwDwl+FsebI8E2MnlgGmzOYoNZfZAQB8ZjhbYrl9JBFgasY7MAAAvxnOFgJMBHkWRQeHhjRqd1YfAJAwo7Z3jHlWhYMW5wDDSSQAQOhxAqk+BJg68EkBAIBfjGcKASaCPKvCvMgLAPCL8UzxLIsHKc4Bpl1SyaJwNstdMAAAfxjOlJKmZ2EsxTbAZNKpcUkmsZYVGACAXwxnSld5FsZSbANMmWdRlJd4AQB+MZwpnlXhMIh7gDF5eamjky0kAIA/DGdKbF/glQgwdenvH9Dk5KRFaQBAgkxOTqq/f8CqPAEmwjyLoqVSSZ1dOYvSAIAE6ezKqVQyOW8isYUUaYZ3wbCNBABYGONZwgpMhHGZHQAgtLjErn4EmDp1cpQaALBAxrOEABNVmXRqSFKvRW1WYAAAC2U4S3rLMzC2Yh1gykwSKAEGALBQhrMk1qsvEgGmbgQYAMBCEWDql4QA41kU7e7pUaFQsCgNAEiAQqGg7p4eq/KeVeGwSEKAMUmhxWJRXblui9IAgAToynWrWCxalWcFJgY4Sg0ACB2OUC9MEgKMZ1WYo9QAgHoZzxDPsngYJCHAmKXQjiy38QIA6mM8Q1iBibpMOtUradiiNiswAIB6Gc6Q4fLsi7XYB5gyz6Io78AAAOplOEM8q8JhkpQAY3QXDFtIAID6GM6Q2G8fSQSYBenKdato9xl0AEBMFUsly6s4CDAxYvIPc2pqSj09sd9mBAD4rKenV1NTU1blCTAx4lkV5kVeAECtOEK9cEkJMHaX2XGUGgBQI+PZwQpMjNgFGFZgAAA1Mp4dBJgY6ZQ0blGYo9QAgFoZzo5xTc+82EtEgMmkUyVJ7Ra1OUoNAKiV4exoL8+82EtEgCkzuguGFRgAQG0MZ0cito+kZAUYz6Iop5AAALUynB2eVeGwSVKAMUmlExOT6uvvtygNAIihvv5+TUxMWpVnBSaGzP6hdrKNBACokvHMIMDEkGdVmKPUAIBqGc8Mz7J4mCQpwLACAwAIHCsw/khSgHlKksmHJzoIMACAKhnOjClNz7pESEyAyaRTBUm7LWqzAgMAqJbhzNhdnnWJkJgAU2ZzFwzvwAAAqmQ4MxKzfSQRYHzBBx0BANUynBkEmBgz+Yc7Mjqq4eERi9IAgBgZHh7RyOioVXkCTIx5VoXZRgIAzIcj1P5JWoAxS6dsIwEA5mM8K1iBiTG7AMMKDABgHsazggATY7slFS0Kc5QaADAfw1lRlNFVIWGVqACTSacmJXVY1O7oZAsJADA3w1nRUZ5xiZGoAFNmssTGCgwAYD6GsyJR20dSMgOMZ1GUd2AAAPMxnBWeVeGwSmKAMUmpAwODGh8ftygNAIiB8fFxDQwMWpVnBSYB7E4isY0EAJiF8YwgwCSAZ1WYbSQAwGy4xM5fSQwwZimVF3kBALMxnhGswCSA4RYSR6kBADMznhEEmLjLpFNjknIWtXkHBgAwG8MZkSvPtkRJXIAp8yyK8g4MAGA2HKH2V1IDjMlSWzZLgAEAzMxwRiRu+0giwPiqt69P+XzeojQAIMLy+bx6+/qsyhNgEsSzKFoqldSVM3m9BgAQYV25nEqlklV5z6pwmCU1wHCZHQDAGS6x8x8BxmcEGADAvggw/ktqgPGsChNgAAD7Mp4NnmXxsEpkgMmkU4OS+i1qd3KUGgCwD8PZ0F+eaYmTyABTZrLk1pHlNl4AwN4MZ0Mit4+kZAcYz6IoKzAAgH0ZzgbPqnDYJTnAmKTWXHePisWiRWkAQAQVi0XlunusyrMCk0Am/9ALhYK6ct0WpQEAEdSV61ahULAqT4BJILN/6GwjAQAqjGcCASaBPKvCHKUGAFRwhNpGkgOM4WV2nEQCAEwzngmswCRNJp3qljRiUZsVGABAheFMGCnPskRKbIApM0muvAMDAKgwnAmJXX2RCDAm//BZgQEAVBjOBAJMghmtwJh+Nh0AEBGlUkmdXTmr8gSYBPMsiubzefX29VmUBgBESG9fn/L5vFV5z6pwFCQ9wBieRGIbCQCSzngWsAKTYAQYAIAZAoydpAcYz6owAQYAwCV2dpIeYLKSJiwKc5QaAGA4CyY0PcMSK9EBJpNOlSTttqidzXIbLwAkneEs2F2eYYmV6ABT5lkUzbICAwCJZzgLPKvCUUGA4TI7AIARLrGzQ4Ax+pdgfHxcAwODFqUBABEwMDCo8fFxq/IEmKAfIATsjlKzjQQAiWU8AwgwQT9ACHhWhTvZRgKAxDKeAZ5l8SggwLACAwAwwAqMLQKMlJFUsCjMUWoASC7DGVDQ9OxKtMQHmEw6ZfYvAiswAJBchjMgU55diZb4AFNmshTHOzAAkFyGMyDx20cSAabC5F+Gjk62kAAgqQxnAAFGBJgKz6Lo8PCIRkZHLUoDAEJsZHRUw8MjVuU9q8JRQoCZZpZm2UYCgOQx/tnPCoykpqAfICTM/mW459/u1Qmrnm1VHgAQQk+0m3wn+OnylsWjggAzzbMqfPcPfmQXwcbKAAABQ0lEQVRVGgCQTF7QDxAGbCFN2y0p0Z8lBwBEQknTMyvxCDCSMunUhKRs0M8BAMA8suWZlXgEmGewpwgACDtmVRkB5hle0A8AAMA8vKAfICwIMM8g1QIAwo5ZVUaAeQb/UgAAwo5ZVUaAeYYX9AMAADAPL+gHCAsCzDNItQCAsGNWlRFgnsG/FACAsGNWlRFgyjLp1Iik7qCfAwCAWXSXZxVEgNkXyRYAEFbMqD0QYPbGvxwAgLBiRu2BALM3L+gHAABgFl7QDxAmBJi9eUE/AAAAs/CCfoAwIcDsjeU5AEBYMaP2QIDZmxf0AwAAMAsv6AcIEwLM3rygHwAAgFl4QT9AmBBg9pBJpwYl9QX9HAAA7KOvPKNQRoDZH3uMAICwYTbtgwCzPy/oBwAAYB9e0A8QNgSY/XlBPwAAAPvwgn6AsPn/DKXzn0MJrDcAAAAASUVORK5CYII=",
          fileName="modelica://ClaRa/figures/Components/MillGeneral.png")}));

end Mill;
