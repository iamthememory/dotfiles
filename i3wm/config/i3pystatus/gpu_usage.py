from i3pystatus import IntervalModule
from i3pystatus.utils import gpu


class GPUUsage(IntervalModule):
    """
    Shows GPU usage

    Currently Nvidia only and nvidia-smi required

    .. rubric:: Available formatters

    * {gpu_usage}
    """

    settings = (
        ('format', 'format string used for output.'),
        ('warn_percentage', 'minimal percentage for warn state'),
        ('alert_percentage', 'minimal percentage for alert state'),
        ("color", "standard color"),
        ("warn_color", "defines the color used when warn percentage is exceeded"),
        ("alert_color", "defines the color used when alert percentage is exceeded"),
        ("gpu_num", 'GPU number'),
    )

    format = '{gpu_usage:02d}%'
    warn_percentage = 50
    alert_percentage = 80
    color = '#00ff00'
    warn_color = '#ffff00'
    alert_color = '#ff0000'
    gpu_num = 0


    def run(self):
        info = gpu.query_nvidia_smi(self.gpu_num)

        if info.usage_gpu >= self.alert_percentage:
            color = self.alert_color
        elif info.usage_gpu >= self.warn_percentage:
            color = self.warn_color
        else:
            color = self.color

        cdict = {
            'gpu_usage': info.usage_gpu
        }

        self.data = cdict
        self.output = {
            'full_text': self.format.format(**cdict),
            'color': color
        }
