# -*- coding: utf-8 -*-
import unittest
from maria import paths
from maria import testutils
from .. import sphinxplugin


class TestPocketsphinxSTTPlugin(unittest.TestCase):

    def setUp(self):
        self.maria_clip = paths.data('audio', 'maria.wav')
        self.time_clip = paths.data('audio', 'time.wav')

        try:
            self.passive_stt_engine = testutils.get_plugin_instance(
                sphinxplugin.PocketsphinxSTTPlugin,
                'unittest-passive', ['JASPER'])
            self.active_stt_engine = testutils.get_plugin_instance(
                sphinxplugin.PocketSphinxSTTPlugin,
                'unittest-active', ['TIME'])
        except ImportError:
            self.skipTest("Pockersphinx not installed!")

    def testTranscribeNaomi(self):
        """
        Does Maria recognize his name (i.e., passive listen)?
        """
        with open(self.naomi_clip, mode="rb") as f:
            transcription = self.passive_stt_engine.transcribe(f)
        self.assertIn("JASPER", transcription)

    def testTranscribe(self):
        """
        Does Maria recognize 'time' (i.e., active listen)?
        """
        with open(self.time_clip, mode="rb") as f:
            transcription = self.active_stt_engine.transcribe(f)
        self.assertIn("TIME", transcription)
